import chalk from 'chalk';
import dotenv from 'dotenv';
import createServer from './controller.js';

dotenv.config();

const app = createServer();

const port = process.env.PORT || 3000;
app.set('view engine', 'ejs').listen(port, error => {
    if (error) {
        console.log(chalk.bgWhite.red(error));
    } else {
        console.log(chalk.bgGreen.white(`Server running on http://localhost:${port}`));
    }
});
