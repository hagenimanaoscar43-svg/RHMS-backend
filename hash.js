const bcrypt = require('bcryptjs');

const plainPassword = "oscar";

const saltRounds = 10;

bcrypt.hash(plainPassword, saltRounds, (err, hash) => {
    if (err) {
        console.error(err);
    } else {
        console.log("Hashed password:", hash);
    }
});const bcrypt = require('bcryptjs');

const password = "rdb@123";

bcrypt.hash(password, 10).then(hash => {
    console.log(hash);
});