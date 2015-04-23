root = exports ? this
root.Posts = new Mongo.Collection 'posts'

# allow the edit/deletion of posts from client 
Posts.allow
    update: (userId,post) -> ownsDocument(userId,post)
    remove: (userId,post) -> ownsDocument(userId,post)

Meteor.methods
    # create postinsert method called from postsubmit
    postInsert: (postAttributes) ->
        check Meteor.userId(), String     # check user id 
        check postAttributes,              # check url/title for string
            title : String
            url : String

        # preventing duplicates
        postWithSameLink = Posts.findOne (url: postAttributes.url)   # link to post w/ same attr
        if postWithSameLink               # if post is found
            return {postExists: true,\    # exit method and return postExists and ID to the post 
                   _id : postWithSameLink._id}


        user = Meteor.user()              # if   
        post = _.extend postAttributes,   # extending post attributes with userId, author
            userId: user._id
            author: user.username
            submitted: new Date()
        postId = Posts.insert(post)

        _id : postId                      # returning userId