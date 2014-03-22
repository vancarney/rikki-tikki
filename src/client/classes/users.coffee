#### RikkiTikki.UserCollection
# Collection to retrieve and manage Parse User Objects
class RikkiTikki.Users extends RikkiTikki.Collection
  url:->
    "#{RikkiTikki.API_URI}/users"