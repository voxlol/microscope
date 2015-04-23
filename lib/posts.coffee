root = exports ? this
root.Posts = new Mongo.Collection 'posts'

Posts.allow
    insert: (userId,doc) ->
        # only allow posting if logged in
        !! userId;