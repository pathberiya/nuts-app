import ballerina/http;

service /product on new http:Listener(9000) {

    resource function get review(string userId) returns Follow[]|error {
        return getFollows(userId);
    }

    resource function post review(@http:Payload FollowEntry entry) returns error?
                             {


                                
        int follow = check addFollow(entry.userId, entry.sku);


    }
}

public type FollowEntry record {|
    string userId;
    string sku;
|};


