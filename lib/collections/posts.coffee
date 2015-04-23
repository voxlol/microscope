root = exports ? this
root.Posts = new Mongo.Collection 'posts'

# allow the edit/deletion of posts from client 
# look like these are true/false cases to where certain post functions will work
Posts.allow
    update: (userId,post) -> return ownsDocument(userId,post)
    remove: (userId,post) -> return ownsDocument(userId,post)
# ensure users can only edit specific fields (callback)
Posts.deny
    update: (userId,post,fieldNames) ->
        return _.without(fieldNames,'url','title').length > 0

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