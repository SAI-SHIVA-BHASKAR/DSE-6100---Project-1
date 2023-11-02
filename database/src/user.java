public class user 
{
		protected String password;
	 	protected String email;
	    protected String firstName;
	    protected String lastName;
	    protected String role;
	 
	    //constructors
	    public user() {
	    }
	 
	    public user(String email) 
	    {
	        this.email = email;
	    }
	    
	    public user(String email,String firstName, String lastName, String password,String role) 
	    {
	    	this(firstName,lastName,password,role);
	    	this.email = email;
	    }
	 
	
	    public user(String firstName, String lastName, String password,String role) 
	    {
	    	this.firstName = firstName;
	    	this.lastName = lastName;
	    	this.password = password;
	        this.role = role;
	    }
	    
	   //getter and setter methods
	    public String getEmail() {
	        return email;
	    }
	    public void setEmail(String email) {
	        this.email = email;
	    }
	    
	    public String getFirstName() {
	        return firstName;
	    }
	    public void setFirstName(String firstName) {
	        this.firstName = firstName;
	    }
	    
	    public String getLastName() {
	        return lastName;
	    }
	    public void setLastName(String lastName) {
	        this.lastName = lastName;
	    }
	    
	    public String getPassword() {
	        return password;
	    }
	    public void setPassword(String password) {
	        this.password = password;
	    }
	  
	    public String getrole() {
	    	return role;
	    }
	    public void setrole(String role) {
	    	this.role = role;
	    }
	  
	}