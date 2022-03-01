const { Pool } = require('pg')

const pool = new Pool({
  host: 'localhost',
  user: 'postgres',
  password: 'password',
  database: 'dp',
  port: '6000'
});

pool.on('error', (err, client) => {
  console.error('Idle client error', err);
  process.exit(-1);
});

const express = require('express')
const cors = require('cors')
const app = express()
const crypto = require('crypto')

const database = 'dp'
const dbUrl = 'http://localhost:6000'

app.use(cors())
app.use(express.json())


app.post('/register', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const {username, mail, password} = req.body;

    const queryTry = 'SELECT id FROM user_account WHERE username=$1';
    const verify = await client.query(queryTry, [username]);
    if (verify.rows[0]) {
      console.log('This username is already used!');
      res.status(602).json({error: 'Username already used!'})
    } else {
      let token = crypto.randomBytes(48).toString('hex')
      await client.query('BEGIN');
      const queryText = 'INSERT INTO user_account (username, mail, password, token) VALUES ($1, $2, $3, $4)';
      await client.query(queryText, [username, mail, password, token]);
      await client.query('COMMIT');
      console.log('User created!');
      res.json({username: username, token: token});
    }

  } catch(e) {
      await client.query('ROLLBACK');
      res.status(601).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});


app.post('/login', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const {username, password} = req.body;

    const queryTry = 'SELECT id FROM user_account WHERE username=$1';
    const verify = await client.query(queryTry, [username]);
    if (!(verify.rows[0])) {
      console.log('Username not registered!');
      res.status(603).json({error: 'Username not registered!'})
    } else {
      const queryTry = 'SELECT id FROM user_account WHERE username=$1 AND password=$2';
      const verify = await client.query(queryTry, [username, password]);
      if (verify.rows[0]) {
        console.log('User logging in!');
        let token = crypto.randomBytes(48).toString('hex')
        await client.query('BEGIN');
        const queryText = 'UPDATE user_account SET token = $1 WHERE username=$2 AND password=$3';
        await client.query(queryText, [token, username, password]);
        await client.query('COMMIT');
        res.json({username: username, token: token})
      } else {
        console.log('Wrong password!');
        res.status(604).json({error: 'Wrong password!'})
      }
    }

  } catch(e) {
      await client.query('ROLLBACK');
      console.log('Something went wrong!');
      res.status(601).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});


app.post('/addActivity', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const {username, name, active} = req.body;

    const queryTry = 'SELECT id FROM user_account WHERE username=$1';
    const userid = await client.query(queryTry, [username]);

    await client.query('BEGIN');
    const queryText = 'INSERT INTO to_do_activity (user_id, name, active) VALUES ($1, $2, $3)';
    await client.query(queryText, [userid.rows[0].id, name, active]);
    await client.query('COMMIT');

    const queryB = 'SELECT id, name, active FROM to_do_activity WHERE user_id=$1 AND active=true';
    const b = await client.query(queryB, [userid.rows[0].id]);

    res.json(b.rows)

  } catch(e) {
      await client.query('ROLLBACK');
      console.log('Something went wrong!');
      res.status(605).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});

app.post('/removeActivity', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const id = req.body.id;

    await client.query('BEGIN');
    const queryText = 'UPDATE to_do_activity SET active=false WHERE id=$1';
    await client.query(queryText, [id]);
    await client.query('COMMIT');

    const queryA = 'SELECT user_id FROM to_do_activity WHERE id=$1';
    const a = await client.query(queryA, [id]);

    const queryB = 'SELECT id, name, active FROM to_do_activity WHERE user_id=$1 AND active=true';
    const b = await client.query(queryB, [a.rows[0].user_id]);

    res.json(b.rows)

  } catch(e) {
      await client.query('ROLLBACK');
      console.log('Something went wrong!');
      res.status(605).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});

app.post('/doneActivity', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const {id, date} = req.body;

    await client.query('BEGIN');
    const queryText = 'UPDATE to_do_activity SET active=false, done=$1 WHERE id=$2';
    await client.query(queryText, [date, id]);
    await client.query('COMMIT');

    const queryA = 'SELECT user_id FROM to_do_activity WHERE id=$1';
    const a = await client.query(queryA, [id]);

    const queryB = 'SELECT id, name, active FROM to_do_activity WHERE user_id=$1 AND active=true';
    const b = await client.query(queryB, [a.rows[0].user_id]);

    res.json(b.rows)

  } catch(e) {
      await client.query('ROLLBACK');
      console.log('Something went wrong!');
      res.status(605).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});

app.get('/getActivities', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const username = req.query.username;
    const queryTry = 'SELECT id FROM user_account WHERE username=$1';
    const userid = await client.query(queryTry, [username]);

    const queryText = 'SELECT id, name, active FROM to_do_activity WHERE user_id=$1 AND active=true';
    const activities = await client.query(queryText, [userid.rows[0].id]);

    res.json(activities.rows)

  } catch(e) {
      await client.query('ROLLBACK');
      console.log('Something went wrong!');
      res.status(605).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});

app.get('/getDoneA', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const username = req.query.username;
    const date = req.query.date;
    const queryTry = 'SELECT id FROM user_account WHERE username=$1';
    const userid = await client.query(queryTry, [username]);

    const queryText = 'SELECT id, name, active FROM to_do_activity WHERE user_id=$1 AND active=false AND done=$2';
    const activities = await client.query(queryText, [userid.rows[0].id, date]);

    res.json(activities.rows)

  } catch(e) {
      await client.query('ROLLBACK');
      console.log('Something went wrong!');
      res.status(605).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});

app.post('/loadUser', async (req, res) => {
  const client = await pool.connect();
  if (client === undefined)
    return console.error('Error client');
  try {
    const {token} = req.body;
    console.error(token);

    const queryTry = 'SELECT username, token FROM user_account WHERE token=$1';
    const user = await client.query(queryTry, [token]);

    res.json({username: user.rows[0].username, token: user.rows[0].token})

  } catch(e) {
      await client.query('ROLLBACK');
      console.log('Something went wrong!');
      res.status(605).json({error: "Something went wrong!"})
  } finally {
      client.release();
  }
});


app.post('/', function (req, res) {

  console.log(req.body)

  res.json({requestBody: req.body})
});

app.listen(5000)
