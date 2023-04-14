class DashboardQueries {
  String parentsChild = """
  query GetParentStudentAssociByParentId(\$token:String!,\$parent_id:ID!){
    GetParentStudentAssociByParentId(token:\$token,parent_id:\$parent_id)
    {
      student_id,
      id
    }
  }""";

  String childDetail = """
query GetStudentAcademicDetailsByIds(\$token:String!,\$_id:[ID!]!)
  {
    GetStudentAcademicDetailsByIds(token:\$token,student_ids:\$_id)
    {
      id,
      first_name
    }
  }""";

  String studentChildDetails="""
  query GetNodeQuery(\$token:String!,\$ids:[ID!]!){
    nodes(token:\$token,ids:\$ids)
    {
      ... on MstStudent {
        first_name
      }
    }
  }
  """;
}
