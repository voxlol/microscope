Router.configure
    layoutTemplate : 'layout'
    loadingTemplate : 'loading'
    notFoundTemplate : 'notFound'
    waitOn : () -> Meteor.subscribe 'posts'

Router.route '/', name : 'postsList'
Router.route '/posts/:_id', 
    name: 'postPage'
    data : () -> Posts.findOne this.params._id

Router.route '/submit', name: 'postSubmit'

# hook for user to be logged in to order 2 route to post submit template
requireLogin = () ->
    if !Meteor.user()
        if Meteor.loggingIn()
            this.loadingTemplate
        else
            this.render 'accessDenied'
    else
        this.next()


Router.onBeforeAction 'dataNotFound', only:'postPage'
Router.onBeforeAction requireLogin, only: 'postSubmit'