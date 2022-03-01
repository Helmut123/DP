module.exports = {
  HOST: "localhost",
  USER: "username",
  PASSWORD: "password",
  DB: "dp",
  dialect: "postgres",
  pool: {
    max: 5,
    min: 0,
    acquire: 15000,
    idle: 10000
  }
};
