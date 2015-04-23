# check that the userId specified owns the documents
root.ownsDocument = (userId,doc) ->
    return doc && doc.userId == userId