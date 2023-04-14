class Queries {
  String studentChannelListQuery = """
  query GetChannelQuery(\$token:String!,\$student_id:ID!){
    GetChannelSubscribedByStudentId(token:\$token,student_id:\$student_id)
    {
      msg_channel_id
    }
  }
  """;
  String nodeQuery = """
  query GetNodeQuery(\$token:String!,\$ids:[ID!]!){
    nodes(token:\$token,ids:\$ids
    )
    {
      id
      ... on MsgChannelMaster {
        channel_name
        channel_desc
        channel_topic
      }
    }
  }
  """;
  String getIDsQuery = """
  query GetNames(\$token:String!,\$student_id:ID!){
  GetAcctDemandMainStudentDemandByStudentId(  
    token:\$token
    student_id:\$student_id,    
  ){        
			first_name,
    	middle_name,
    	last_name
  }
}
  """;
  String addChatQuery = """
mutation AddChMsg(\$token:String!,\$msg_channel_id:ID!,\$msg_content:String,\$student_id:ID!,\$msg_media_content:String,\$msg_media_type:String){
  AddChannelMessage(
  token:\$token
  input:{
    msg_content:\$msg_content
    msg_channel_id:\$msg_channel_id
    msg_media_content:\$msg_media_content
    msg_media_type:\$msg_media_type
    student_id:\$student_id
    parent_id:0
    staff_id:0
    eduate_id:0
    
    
  })
  {
    id
    msg_content
    msg_media_content
  }
}
  """;
  String messagesSubscriptions = """
  subscription GetNames(\$token : String!){
  GetChannelMessagesBySubscription(  
  token:\$token
  ){
      msg_content
      msg_media_content
			msg_media_type
			msg_active
			student_id
			created_at
}
}
  """;
  String getLastMsg = """
  query GetChMsgs(\$token:String!,\$msg_channel_id:ID!, \$last:Int) {
  GetChannelMessagesByMsgChannelId(token: \$token,msg_channel_id:\$msg_channel_id,
  orderBy:{direction:ASC, field:CREATED_AT},
  last:\$last
  ){
  edges{
  node{
  msg_content
  msg_media_type
  msg_active
  student_id
  created_at
  }
  cursor
  }

  }
  }
  """;
  String messagesQuery = """
query GetChMsgs(\$token:String!,\$msg_channel_id:ID!,\$searchString:String!, \$last:Int) {
  GetChannelMessagesByMsgChannelId(token: \$token,msg_channel_id:\$msg_channel_id,    
    orderBy:{direction:ASC, field:CREATED_AT},
    last:\$last,    
    where: {or:{msgContentContainsFold: \$searchString}}

  ){
    pageInfo {
      hasPreviousPage
      startCursor
      endCursor
      }
    edges{
      node{        
			msg_content
	    msg_media_content
			msg_media_type
			msg_active
			student_id
			created_at
    } 
      cursor
    }
    
  }
}
  """;
  String getReadCountQuery = """
  query GetChannelReadCountByStudentId(\$token:String!,\$msg_channel_ids:[ID!]!, \$student_id:ID!){
  GetChannelReadCountByStudentId(  
    token:\$token
    msg_channel_ids: \$msg_channel_ids
    student_id:\$student_id,    
  ){        
			msg_read_count,
      msg_channel_id,
  }
}
  """;

//   String updateReadCountQuery=
//   """ mutation GetChannelReadCountByStudentId(\$token:String!,\$msg_channel_ids:[ID!]!, \$student_id:ID!){
//   GetChannelReadCountByStudentId(
//     token:\$token
//     msg_channel_ids: \$msg_channel_ids
//     student_id:\$student_id,
//   ){
// 			msg_read_count,
//       msg_channel_id,
//   }
// }

// """;
}
