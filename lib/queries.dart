String getUserProfileWithId = """ 
    query getUserProfile (\$id: Int!) {
      users(where: {id: {_eq: \$id } }) {
        id 
        full_name
        email
        department
        about
        role 
        uuid
      }
      
    }
  """;

String getAdmins = """ 
   query getAdmins {
      users(where: { user_roles: { role_id: {_eq: 1}}}) {
        full_name
      }
    }
  """;

String getAllChannelsForUserQuery = """
  query getAllChannelsForUserQuery (\$id: Int!) {
      channel (where: { channel_users: { user_id: {_eq: \$id}}}) {
        id
        name
      }
    }
  """;

String getAllUsersQuery = """
  query getAllUsers {
    users{
      id
      email
      full_name
      role
      department
    }
  }
""";

String getUsersNotOnChannel = """
  query getUsersNotOnChannel (\$channelId: Int!) {
    users(where: {_not: {channel_users:  {channel_id: {_eq:\$channelId } } } }) {
      id
      full_name
      department
      role
    }
  }
""";

String addUsersToChannel = """
 mutation addUsersToChannel (\$objects: [channel_users_insert_input!]!) {
  insert_channel_users(objects: \$objects) {
    affected_rows
  }
}
""";
