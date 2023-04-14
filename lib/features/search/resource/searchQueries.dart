class SearchQueries {
  String studentChannelListQuery = """
  query GetStudentsQuery(\$token:String!,\$msg_channel_id:ID!){
    GetStudentsByChannelId(token:\$token,msg_channel_id:\$msg_channel_id)
    {
      first_name
    }
  }
  """;
  String channels = """
  query GetChannelQuery(\$token:String!,\$student_id:ID!){
    GetChannelSubscribedByStudentId(token:\$token,student_id:\$student_id)
    {
      msg_channel_id
    }
  }
  """;
  String nodeQuery = """
  query GetNodeQuery(\$token:String!,\$ids:[ID!]!){
    nodes(token:\$token,ids:\$ids)
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
}
