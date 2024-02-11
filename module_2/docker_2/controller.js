import express from 'express';
import { v4 as uuidv4 } from 'uuid';

export default function createServer() {
    const app = express();

    app.get('/', (req, res) => {
        const data = { message: 'Hello, World!' };
        res.setHeader('Content-Type', 'application/json');
        res.status(200).json(data);
    });

    app.get('/healthz', (req, res) => {
        const data = { status: 'OK' };
        res.setHeader('Content-Type', 'application/json');
        res.status(200).json(data);
    });

    app.get('/uuid', (req, res) => {
        const data = { uuid: uuidv4() };
        res.setHeader('Content-Type', 'application/json');
        res.status(200).json(data);
    });

    return app;
}

