root = exports ? this
root.Posts = new Mongo.Collection 'posts'

Meteor.methods
    # create postinsert method called from postsubmit
    postInsert: (postAttributes) ->
        check Meteor.userId(), String     # check user id 
        check postAttributes              # check url/title for string
            title : String
            url : String
        user = Meteor.user()              # if   
        post = _.extend postAttributes, 
            userId: user._id
            author: user.username
            submitted: new Date()
        postId = Posts.insert(post)

        _id : postId