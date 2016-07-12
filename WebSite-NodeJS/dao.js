var mysql = require('mysql')
var conn = mysql.createConnection({
	host: '127.0.0.1',
	port: 3306,
	user: 'root',
	password: 'root',
	database: 'ustb_choose_course',
	charset: 'utf8'
});
conn.connect();


var db = {
	queryAPPInfo: function(operation){
		conn.query('select * from `apps`',
			function(err, results){
				if(err){
					throw err;
				}else{
					operation(results);					
				}

			});
	},

	addMessage: function(param, operation){

		conn.query('INSERT INTO message_boards(id, parent_id ,nickname , replyer_name, content, time) VALUES(0, ?, ?, ?, ?, ?)',
			[
				param.parent_id,
				param.nickname,
				param.replyer_name,
				param.content,
				param.time
			],
			function(err, results){
				if(err){
					throw err;
				}else{
					operation(results);				
				}

			});

	},

	queryMessageBoard:  function(operation){
		conn.query('select * from `message_boards`',
			function(err, results){
				if(err){
					throw err;
				}else{
					operation(results);					
				}

			});
	}

};


module.exports = db;