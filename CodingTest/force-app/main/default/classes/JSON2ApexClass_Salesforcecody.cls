public class JSON2ApexClass_Salesforcecody{
	 public List<String> destination_addresses;
	 public List<String> origin_addresses;
	 public List<cls_rows> rows;
	 public String status;	
	
   
	public class cls_rows {
		 public List<cls_elements> elements;
	}
	public class cls_elements {
		 public cls_distance distance;
		 public cls_duration duration;
		 public String status;	
	}
	public class cls_distance {
		 public String text;	//228 mi
		 public Integer value;	//367654
	}
	public class cls_duration {
		 public String text;	//3 hours 55 mins
		 public Integer value;	//14078
	}
	public static JSON2ApexClass_Salesforcecody parse(String json){
		return (JSON2ApexClass_Salesforcecody) System.JSON.deserialize(json, JSON2ApexClass_Salesforcecody.class);
	}

	
}