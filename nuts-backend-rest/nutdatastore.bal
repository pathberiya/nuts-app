import ballerinax/mysql.driver as _;
import ballerinax/mysql;
import ballerina/sql;
import ballerina/log;


type Database record {|
    string host;
    string name;
    int port;
    string username;
    string password;
|};

type Follow record {|
    string id;
    string user_id;
    string product_id;
    boolean follow;
|};



configurable Database database = ?;

final mysql:Client dbClient = check new (database.host, database.username, database.password, database.name, database.port);


function getFollows(string? userId) returns Follow []|error {

    log:printInfo("function is called ###########");

    Follow[] follows = [];

    stream<Follow, error?>  resultStream = dbClient->query(`select  * from product_review where user_id=${userId}`);

    check from Follow employee in resultStream
        do {
            follows.push(employee);
        };
  
    check resultStream.close();
    log:printInfo(follows.toJsonString());

    return follows;
}

function addFollow(string? userId, string? sku) returns int|error {

    log:printInfo("function is called ###########");

    sql:ExecutionResult finalResult = check dbClient->execute(
        `INSERT INTO product_review(user_id, product_id, follow) VALUES 
        (${userId}, (SELECT id from product WHERE sku = ${sku}) , true)`);

    return <int>finalResult.lastInsertId;
}


