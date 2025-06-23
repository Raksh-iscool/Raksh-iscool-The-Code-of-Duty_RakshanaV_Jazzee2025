const express = require('express');
const multer = require('multer');
const cors = require('cors');
const fs = require('fs');
const path = require('path');
const { AccessToken } = require('livekit-server-sdk');

const app = express();
const port = 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Configure multer for file uploads
const upload = multer({
    dest: 'uploads/',
    limits: {
        fileSize: 10 * 1024 * 1024 // 10MB limit
    }
});

// Store for audio files (in production, use cloud storage)
app.use('/audio', express.static('audio'));

// Environment variables (in production, use proper env vars)
const LIVEKIT_API_KEY = process.env.LIVEKIT_API_KEY || 'your-livekit-api-key';
const LIVEKIT_API_SECRET = process.env.LIVEKIT_API_SECRET || 'your-livekit-api-secret';
const OPENAI_API_KEY = process.env.OPENAI_API_KEY || 'your-openai-api-key';
const ELEVENLABS_API_KEY = process.env.ELEVENLABS_API_KEY || 'your-elevenlabs-api-key';

/**
 * Generate LiveKit access token for story session
 */
app.post('/generate-livekit-token', async (req, res) => {
    try {
        const roomName = `story-room-${Date.now()}`;
        const participantName = `storyteller-${Date.now()}`;

        const at = new AccessToken(LIVEKIT_API_KEY, LIVEKIT_API_SECRET, {
            identity: participantName,
        });

        at.addGrant({
            room: roomName,
            roomJoin: true,
            canPublish: true,
            canSubscribe: true,
        });

        const token = at.toJwt();

        res.json({
            token,
            room: roomName,
            participant: participantName
        });
    } catch (error) {
        console.error('Error generating LiveKit token:', error);
        res.status(500).json({ error: 'Failed to generate token' });
    }
});

/**
 * Process story audio: STT -> LLM -> TTS pipeline
 */
app.post('/process-story-audio', upload.single('audio'), async (req, res) => {
    try {
        if (!req.file) {
            return res.status(400).json({ error: 'No audio file provided' });
        }

        const audioPath = req.file.path;
        const sessionId = req.body.session_id || `session-${Date.now()}`;

        console.log(`Processing audio for session: ${sessionId}`);

        // Step 1: Speech-to-Text (STT)
        const transcription = await speechToText(audioPath);
        console.log('Transcription:', transcription);

        // Step 2: Generate AI story response using LLM with session context
        const aiResponse = await generateStoryResponseWithContext(transcription, sessionId);
        console.log('AI Response:', aiResponse);

        // Step 3: Text-to-Speech (TTS)
        const audioUrl = await textToSpeech(aiResponse, sessionId);
        console.log('Generated audio URL:', audioUrl);

        // Update session context
        if (storySessions.has(sessionId)) {
            const session = storySessions.get(sessionId);
            session.storyContext.push({
                userInput: transcription,
                aiResponse: aiResponse,
                audioUrl: audioUrl,
                timestamp: new Date()
            });
            session.totalInteractions++;
        }

        // Clean up uploaded file
        fs.unlinkSync(audioPath);

        res.json({
            transcription,
            ai_response: aiResponse,
            audio_url: audioUrl,
            session_id: sessionId
        });
    } catch (error) {
        console.error('Error processing story audio:', error);
        res.status(500).json({ error: 'Failed to process audio' });
    }
});

/**
 * Story setup endpoint
 */
app.post('/story-setup', async (req, res) => {
    try {
        const { characters, prompt, imagePath } = req.body;

        console.log('Story setup:', {
            characters: characters?.map(c => c.name),
            prompt: prompt?.substring(0, 50) + '...',
            hasImage: !!imagePath
        });

        // Store story setup in session (in production, use proper storage)
        // This would be used to maintain story context

        res.json({
            success: true,
            message: 'Story setup complete'
        });
    } catch (error) {
        console.error('Error in story setup:', error);
        res.status(500).json({ error: 'Failed to setup story' });
    }
});

// Store for active story sessions (in production, use Redis or database)
const storySessions = new Map();

/**
 * Get or create story session
 */
app.post('/story-session', async (req, res) => {
    try {
        const { sessionId, storySetup } = req.body;

        if (!sessionId) {
            return res.status(400).json({ error: 'Session ID is required' });
        }

        // Create or update session
        if (!storySessions.has(sessionId)) {
            storySessions.set(sessionId, {
                id: sessionId,
                createdAt: new Date(),
                storyContext: [],
                setup: storySetup || null,
                totalInteractions: 0
            });
        }

        const session = storySessions.get(sessionId);

        if (storySetup) {
            session.setup = storySetup;
        }

        res.json({
            success: true,
            session: {
                id: session.id,
                hasSetup: !!session.setup,
                interactions: session.totalInteractions,
                createdAt: session.createdAt
            }
        });
    } catch (error) {
        console.error('Error managing story session:', error);
        res.status(500).json({ error: 'Failed to manage session' });
    }
});

/**
 * Get story session history
 */
app.get('/story-session/:sessionId', async (req, res) => {
    try {
        const { sessionId } = req.params;

        if (!storySessions.has(sessionId)) {
            return res.status(404).json({ error: 'Session not found' });
        }

        const session = storySessions.get(sessionId);

        res.json({
            success: true,
            session: {
                id: session.id,
                setup: session.setup,
                storyContext: session.storyContext,
                totalInteractions: session.totalInteractions,
                createdAt: session.createdAt
            }
        });
    } catch (error) {
        console.error('Error retrieving story session:', error);
        res.status(500).json({ error: 'Failed to retrieve session' });
    }
});

/**
 * Generate story continuation without audio
 */
app.post('/generate-story', async (req, res) => {
    try {
        const { prompt, sessionId } = req.body;

        if (!prompt) {
            return res.status(400).json({ error: 'Prompt is required' });
        }

        const finalSessionId = sessionId || `session-${Date.now()}`;

        console.log(`Generating story for session: ${finalSessionId}`);

        // Generate AI story response
        const aiResponse = await generateStoryResponse(prompt, finalSessionId);

        // Update session context
        if (storySessions.has(finalSessionId)) {
            const session = storySessions.get(finalSessionId);
            session.storyContext.push({
                userInput: prompt,
                aiResponse: aiResponse,
                timestamp: new Date()
            });
            session.totalInteractions++;
        }

        res.json({
            story: aiResponse,
            session_id: finalSessionId
        });
    } catch (error) {
        console.error('Error generating story:', error);
        res.status(500).json({ error: 'Failed to generate story' });
    }
});

/**
 * Generate audio from text
 */
app.post('/generate-audio', async (req, res) => {
    try {
        const { text, sessionId } = req.body;

        if (!text) {
            return res.status(400).json({ error: 'Text is required' });
        }

        const finalSessionId = sessionId || `session-${Date.now()}`;

        console.log(`Generating audio for session: ${finalSessionId}`);

        // Generate TTS audio
        const audioUrl = await textToSpeech(text, finalSessionId);

        res.json({
            audio_url: audioUrl,
            session_id: finalSessionId
        });
    } catch (error) {
        console.error('Error generating audio:', error);
        res.status(500).json({ error: 'Failed to generate audio' });
    }
});

/**
 * Speech-to-Text using OpenAI Whisper
 */
async function speechToText(audioPath) {
    try {
        if (OPENAI_API_KEY === 'your-openai-api-key') {
            console.warn('Using mock transcription - OpenAI API key not configured');
            return "Once upon a time, there was a brave knight who went on an adventure...";
        }

        const FormData = require('form-data');
        const axios = require('axios');

        const formData = new FormData();
        formData.append('file', fs.createReadStream(audioPath));
        formData.append('model', 'whisper-1');
        formData.append('language', 'en');

        const response = await axios.post('https://api.openai.com/v1/audio/transcriptions', formData, {
            headers: {
                ...formData.getHeaders(),
                'Authorization': `Bearer ${OPENAI_API_KEY}`,
            },
            timeout: 30000, // 30 second timeout
        });

        return response.data.text;
    } catch (error) {
        console.error('Error in speech-to-text:', error.message);
        // Fallback to mock transcription
        return "I heard you say something wonderful! Let me continue our story...";
    }
}

/**
 * Generate story response using LLM (OpenAI GPT)
 */
async function generateStoryResponse(userInput, sessionId) {
    try {
        if (OPENAI_API_KEY === 'your-openai-api-key') {
            console.warn('Using mock story response - OpenAI API key not configured');
            return getMockStoryResponse();
        }

        const axios = require('axios');

        const response = await axios.post('https://api.openai.com/v1/chat/completions', {
            model: 'gpt-4o-mini', // More cost-effective than gpt-4
            messages: [
                {
                    role: 'system',
                    content: `You are a creative storyteller for children aged 6-10. 
                             Create engaging, safe, and educational interactive stories. 
                             Keep responses under 150 words and always maintain a positive, encouraging tone.
                             Never include scary, violent, or inappropriate content.
                             Always end with a question or choice to keep the child engaged.
                             Make the story magical and full of wonder.
                             Session ID: ${sessionId}`
                },
                {
                    role: 'user',
                    content: userInput
                }
            ],
            max_tokens: 200,
            temperature: 0.8,
            presence_penalty: 0.1,
            frequency_penalty: 0.1
        }, {
            headers: {
                'Authorization': `Bearer ${OPENAI_API_KEY}`,
                'Content-Type': 'application/json',
            },
            timeout: 30000, // 30 second timeout
        });

        return response.data.choices[0].message.content;
    } catch (error) {
        console.error('Error generating story response:', error.message);
        // Fallback to mock response
        return getMockStoryResponse();
    }
}

/**
 * Generate story response with session context for continuity
 */
async function generateStoryResponseWithContext(userInput, sessionId) {
    try {
        if (OPENAI_API_KEY === 'your-openai-api-key') {
            console.warn('Using mock story response - OpenAI API key not configured');
            return getMockStoryResponse();
        }

        const axios = require('axios');

        // Get session context
        const session = storySessions.get(sessionId);
        const messages = [
            {
                role: 'system',
                content: `You are a creative storyteller for children aged 6-10. 
                         Create engaging, safe, and educational interactive stories. 
                         Keep responses under 150 words and always maintain a positive, encouraging tone.
                         Never include scary, violent, or inappropriate content.
                         Always end with a question or choice to keep the child engaged.
                         Make the story magical and full of wonder.
                         Maintain story continuity and remember previous interactions.
                         Session ID: ${sessionId}`
            }
        ];

        // Add story setup context if available
        if (session?.setup) {
            messages.push({
                role: 'system',
                content: `Story Setup: Characters: ${session.setup.characters?.map(c => c.name).join(', ') || 'None specified'}. 
                         Story Prompt: ${session.setup.prompt || 'Free-form story'}. 
                         Use this setup to guide the story direction.`
            });
        }

        // Add recent story context (last 5 interactions to avoid token limits)
        if (session?.storyContext) {
            const recentContext = session.storyContext.slice(-5);
            for (const context of recentContext) {
                messages.push({
                    role: 'user',
                    content: context.userInput
                });
                messages.push({
                    role: 'assistant',
                    content: context.aiResponse
                });
            }
        }

        // Add current user input
        messages.push({
            role: 'user',
            content: userInput
        });

        const response = await axios.post('https://api.openai.com/v1/chat/completions', {
            model: 'gpt-4o-mini',
            messages: messages,
            max_tokens: 200,
            temperature: 0.8,
            presence_penalty: 0.1,
            frequency_penalty: 0.1
        }, {
            headers: {
                'Authorization': `Bearer ${OPENAI_API_KEY}`,
                'Content-Type': 'application/json',
            },
            timeout: 30000,
        });

        return response.data.choices[0].message.content;
    } catch (error) {
        console.error('Error generating contextual story response:', error.message);
        // Fallback to regular story generation
        return generateStoryResponse(userInput, sessionId);
    }
}

/**
 * Get a mock story response for fallback
 */
function getMockStoryResponse() {
    const responses = [
        "What an exciting beginning! The brave knight looked around the magical forest and saw sparkling lights dancing between the trees. 'I wonder what adventures await me here,' the knight thought. Suddenly, a friendly fairy appeared with a warm smile. 'Welcome, brave knight! I've been waiting for someone just like you to help save our enchanted garden.' What do you think the knight should do next?",

        "That's a wonderful idea! The knight decided to help the fairy right away. Together, they walked deeper into the forest where they discovered a beautiful garden that had lost all its colors. 'The mean storm took away our rainbow flowers,' explained the fairy sadly. But the knight had an idea - they could search for the magical rainbow seeds that were scattered by the wind. Should we look by the sparkling stream or near the wise old oak tree?",

        "Great choice! Near the wise old oak tree, they found the first rainbow seed glowing softly in the grass. As soon as the knight picked it up, a tiny bit of red color returned to one flower! 'We need to find six more seeds to bring back all the colors,' said the fairy excitedly. The knight felt proud to be helping. Where should our brave heroes search next for the remaining rainbow seeds?"
    ];

    return responses[Math.floor(Math.random() * responses.length)];
}

/**
 * Text-to-Speech using ElevenLabs
 */
async function textToSpeech(text, sessionId) {
    try {
        if (ELEVENLABS_API_KEY === 'your-elevenlabs-api-key') {
            console.warn('Using mock audio URL - ElevenLabs API key not configured');
            return getMockAudioUrl();
        }

        const axios = require('axios');

        // Use a child-friendly voice (you can change this voice ID)
        const voiceId = '21m00Tcm4TlvDq8ikWAM'; // Rachel voice (warm, friendly)

        const response = await axios.post(`https://api.elevenlabs.io/v1/text-to-speech/${voiceId}`, {
            text: text,
            model_id: 'eleven_monolingual_v1',
            voice_settings: {
                stability: 0.75,
                similarity_boost: 0.75,
                style: 0.2,
                use_speaker_boost: true
            }
        }, {
            headers: {
                'Accept': 'audio/mpeg',
                'xi-api-key': ELEVENLABS_API_KEY,
                'Content-Type': 'application/json',
            },
            responseType: 'stream',
            timeout: 30000, // 30 second timeout
        });

        const audioFileName = `story_${sessionId}_${Date.now()}.mp3`;
        const audioPath = path.join('audio', audioFileName);

        // Ensure audio directory exists
        if (!fs.existsSync('audio')) {
            fs.mkdirSync('audio', { recursive: true });
        }

        const writer = fs.createWriteStream(audioPath);
        response.data.pipe(writer);

        return new Promise((resolve, reject) => {
            writer.on('finish', () => {
                console.log(`Audio generated: ${audioPath}`);
                resolve(`/audio/${audioFileName}`);
            });
            writer.on('error', (error) => {
                console.error('Error writing audio file:', error);
                reject(error);
            });
        });
    } catch (error) {
        console.error('Error in text-to-speech:', error.message);
        // Fallback to mock audio URL
        return getMockAudioUrl();
    }
}

/**
 * Get a mock audio URL for fallback
 */
function getMockAudioUrl() {
    // Return a sample audio file URL for testing
    return `https://www.soundjay.com/misc/sounds/bell-ringing-05.wav`;
}

// Health check endpoint
app.get('/health', (req, res) => {
    res.json({
        status: 'healthy',
        timestamp: new Date().toISOString(),
        message: 'Tellie  Backend is running!',
        services: {
            openai: OPENAI_API_KEY !== 'your-openai-api-key' ? 'configured' : 'not configured',
            elevenlabs: ELEVENLABS_API_KEY !== 'your-elevenlabs-api-key' ? 'configured' : 'not configured',
            livekit: LIVEKIT_API_KEY !== 'your-livekit-api-key' ? 'configured' : 'not configured'
        },
        activeSessions: storySessions.size
    });
});

// Get all active sessions (for debugging)
app.get('/debug/sessions', (req, res) => {
    const sessions = Array.from(storySessions.entries()).map(([id, session]) => ({
        id,
        createdAt: session.createdAt,
        interactions: session.totalInteractions,
        hasSetup: !!session.setup
    }));

    res.json({
        totalSessions: sessions.length,
        sessions
    });
});

// Clear all sessions (for testing)
app.delete('/debug/sessions', (req, res) => {
    const count = storySessions.size;
    storySessions.clear();

    res.json({
        message: `Cleared ${count} sessions`,
        timestamp: new Date().toISOString()
    });
});

// Start server
app.listen(port, () => {
    console.log(`🚀 Tellie  Backend running on http://localhost:${port}`);
    console.log(`📚 Health check: http://localhost:${port}/health`);
    console.log(`🎙️  Ready to process story audio!`);
});

module.exports = app;
