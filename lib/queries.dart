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
      uuid
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

String getMessagesForChannel = """
  subscription getMessagesForChannel(\$channelId: Int!) {
    message(where: {channel_id: {_eq: \$channelId } } order_by: {created_at: desc}) {
      created_at
      id
      content
      user_id
      user{
        uuid
      }
      channel_id
      type
    }
  }
""";

String clearProposals = """
  mutation clearProposals(\$vehicle_idd: Int!, \$session_idd: Int!) {
  
  update_proposal_pool(where:{} _set: {ended:true}){
    affected_rows
  }
  
  insert_proposal_pool_one(object: {
    session_id: \$session_idd,
    vehicle_id: \$vehicle_idd,
    ended: false,
    proposals: {data: [{ title: "Health Check 1", description: "", reason: ""},{ title: "Health Check 2", description: "", reason: ""}]}
  }){
    id
  }
  
}
""";

String getCurrentProposalPool = """
  subscription getCurrentProposalPool {
    event_date(order_by: {id: desc}, limit: 1){
      id
      date
      description
      sessions (order_by: {id: asc}, limit: 1, where:{proposal_pools: {ended :{_eq: false}}}){
        id
      	racetrack{
          id
          name
          country
          country_code
        }
      	type
        proposal_pools(order_by: {id: desc}, limit: 1, where:{ended: {_eq: false}}){
        vehicle{
          id
          name
          year
          description
          systems{
            id
            name
            description
            subsystems{
              id
              name
              description
              parts{
                id
                name
                measurement_unit
                part_values{
                  id
                  value
                }
              }
            }
          }
          
        }  
        id
        }
      }
    }
  }

""";

String getProposalsFromProposalPool = """
  subscription getProposalsFromProposalPool(\$proposal_pool_id: Int!){
    proposal(where: {proposal_pool_id: {_eq: \$proposal_pool_id}}, order_by:{created_at:desc}) {
    id
    part_id
    user_id
    part_value_from
    part_value_to
    title
    description
    reason
    user{
      department
    }
    proposal_pool_id
    proposal_states(order_by:{created_at:desc}){
      id
      state
      proposal_id
      changed_by_user_id
    }
    }
  }
""";

String getApprovedProposals = """
  subscription getApprovedProposals {
    proposal_pool(order_by: {id: asc}, limit:1, where: {ended:{_eq:false}}){
      id
      proposals(where: {_or: [{proposal_states: {state: {_eq:"APPROVED"} } }, {user_id: {_is_null:true} } ]}) {
        id
        title
        created_at
        proposal_pool_id
        part_id
        user_id
        description
        reason
        part_value_from
        part_value_to
        proposal_states(limit:1, order_by:{id: desc}){
          id
          proposal_id
          state
          changed_by_user_id
        }
      }
    }
  }
""";

String insertEvent = """
  mutation insertEvent(\$description: String!, \$date: timestamp!, \$sessions: [session_insert_input!]!) {
    update_proposal_pool(where: {}, _set:{ended:true}){
    affected_rows
    }
    
    insert_event_date_one(object: {description: \$description,
      date: \$date,
      sessions: {data: \$sessions } 
    } ) {
      id
      description
      date
      sessions {
        id
      } 
    }  
  }

""";

String getLatestProposalForDepartment = """
  query getLatestProposalForDepartment(\$department: String!, \$eventId: Int!, \$sessionId: Int! ) {
    event_date(limit: 1, where: {id: {_eq: \$eventId}}) {
      sessions(limit: 1, where: {id: {_eq: \$sessionId}}){
        proposal_pools(limit: 1, order_by: {id: desc }){
          id
          proposals(where: {user: {department: {_eq: \$department}} }, order_by: {id: desc }) {
            id
            proposal_pool{
              id
              vehicle{
                id
              }
            }
            part{
              id
              name
              measurement_unit
            }
            part_id
            user_id
            title
            description
            reason
            part_value_from
            part_value_to
          }
        }
      }
    }
  }
""";

String getAllEvents = """
  subscription getAllEvents {
    event_date(where: {id: {_gt:1}}) {
      id
      description
      date
      sessions{
        id
        proposal_pools(order_by: {id: desc}, limit: 1){
          vehicle{
            name
          }
        }
        session_order
        type
        racetrack {
          id
          country_code
          country
          name
        }
       laps{
          id
          lap_order
          created_at
        }
      }
    }
  }

""";

String getLatestSession = """
  subscription getLatestSession {
    event_date(order_by: {id: desc}, limit: 1){
      id
      date
      description
      sessions (order_by: {id: desc}, limit: 1){
        id
      }
    }
  }
""";

String getEventDetails = """
  query getEventDetails(\$eventId: Int!) {
    event_date(where:{id: {_eq: \$eventId } }){
      id
      date 
      description
      sessions{
        id
        
        type
        racetrack {
          id
          name
          country
          country_code
        }  
        proposal_pools(where: {ended: {_eq: false}}) {
          id
          vehicle{
            name
          }
          ended
        }
      }
    }
  }
""";

String selectSession = """
  mutation selectSession(\$sessionId: Int!, \$eventId: Int!){
    update_proposal_pool_many(updates:{_set:{ended: true}where:{_and: [{session_id:{_lt:\$sessionId}}, {session:{event_date_id:{_eq:\$eventId}}}]  } }){
      affected_rows
    }
  }
""";

String endEvent = """
  mutation endEvent(\$eventId: Int!){
    update_proposal_pool_many(updates:{_set:{ended: true} where :{ session:{ event_date_id:{_eq:\$eventId} } } } ){
      affected_rows
    }
  }
""";

String getUserProfileStream = """
  subscription getUserProfile(\$userId: Int!){
    users(where: { id: {_eq: \$userId}}){
    id
    role
    uuid
    about
    email
    active
    provider
    full_name
    department
    
  }
}
""";
