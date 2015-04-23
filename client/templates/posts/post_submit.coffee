Template.postSubmit.events
    'submit form' : (e) ->
        e.preventDefault()


        # creating the post object to send to the meteor server method
        post = 
            url: $(e.target).find('[name=url]').val()
            title: $(e.target).find('[name=title]').val()
        

        # call the meteor-server method postInsert
        # parameters passed : post
        Meteor.call 'postInsert', post, (error,result) ->
            # display the error to the user and abort
            if error
                alert(error.reason)

            # show the result but route anyway
            if result.postExists
                alert 'This link has already been posted'

            # route to the postPage
            Router.go 'postPage', _id: result._id