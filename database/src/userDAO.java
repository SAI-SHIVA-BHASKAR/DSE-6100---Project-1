import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;
import java.sql.PreparedStatement;
//import java.sql.Connection;
//import java.sql.PreparedStatement;
import java.sql.ResultSet;
//import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
/**
 * Servlet implementation class Connect
 */
@WebServlet("/userDAO")
public class userDAO 
{
	private static final long serialVersionUID = 1L;
	private Connection connect = null;
	private Statement statement = null;
	private PreparedStatement preparedStatement = null;
	private ResultSet resultSet = null;
	
	public userDAO(){}
	
	/** 
	 * @see HttpServlet#HttpServlet()
     */
    protected void connect_func() throws SQLException {
    	//uses default connection to the database
        if (connect == null || connect.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new SQLException(e);
            }
            connect = (Connection) DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/testdb?allowPublicKeyRetrieval=true&useSSL=false&user=john&password=pass1234");
            System.out.println(connect);
        }
    }
    
    public boolean database_login(String email, String password) throws SQLException{
    	try {
    		connect_func("root","pass1234");
    		String sql = "select * from signup_users where email = ? and password = ?";
    		preparedStatement = connect.prepareStatement(sql);
    		preparedStatement.setString(1, email);
    		ResultSet rs = preparedStatement.executeQuery();
    		return rs.next();
    	}
    	catch(SQLException e) {
    		System.out.println("failed login");
    		return false;
    	}
    }
	//connect to the database 
    public void connect_func(String username, String password) throws SQLException {
        if (connect == null || connect.isClosed()) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
            } catch (ClassNotFoundException e) {
                throw new SQLException(e);
            }
            connect = (Connection) DriverManager
  			      .getConnection("jdbc:mysql://127.0.0.1:3306/testdb?"
  			          + "useSSL=false&user=" + username + "&password=" + password);
            System.out.println(connect);
        }
    }
    
    public List<user> listAllUsers() throws SQLException {
        List<user> listUser = new ArrayList<user>();        
        String sql = "SELECT * FROM signup_users";      
        connect_func();      
        statement = (Statement) connect.createStatement();
        ResultSet resultSet = statement.executeQuery(sql);
         
        while (resultSet.next()) {
            String email = resultSet.getString("email");
            String FirstName = resultSet.getString("firstName");
            String LastName = resultSet.getString("lastName");
            String password = resultSet.getString("password");
            String role = resultSet.getString("role");
             
            user signup_users = new user(email, FirstName, LastName, password, role);
            listUser.add(signup_users);
        }        
        resultSet.close();
        disconnect();        
        return listUser;
    }
    
    protected void disconnect() throws SQLException {
        if (connect != null && !connect.isClosed()) {
        	connect.close();
        }
    }
    
    public void insert(user signup_users) throws SQLException {
    	connect_func("root","pass1234");         
		String sql = "insert into signup_users(email, FirstName, LastName, password, role) values (?, ?, ?, ?, ?)";
		preparedStatement = (PreparedStatement) connect.prepareStatement(sql);
			preparedStatement.setString(1, signup_users.getEmail());
			preparedStatement.setString(2, signup_users.getFirstName());
			preparedStatement.setString(3, signup_users.getLastName());
			preparedStatement.setString(4, signup_users.getPassword());
			preparedStatement.setString(5, signup_users.getrole());		

		preparedStatement.executeUpdate();
        preparedStatement.close();
    }
    
    public boolean delete(String email) throws SQLException {
        String sql = "DELETE FROM signup_users WHERE email = ?";        
        connect_func();
         
        preparedStatement = (PreparedStatement) connect.prepareStatement(sql);
        preparedStatement.setString(1, email);
         
        boolean rowDeleted = preparedStatement.executeUpdate() > 0;
        preparedStatement.close();
        return rowDeleted;     
    }
     
    public boolean update(user signup_users) throws SQLException {
        String sql = "update signup_users set FirstName=?, LastName =?,password = ?, role =?";
        connect_func();
        
        preparedStatement = (PreparedStatement) connect.prepareStatement(sql);
        preparedStatement.setString(1, signup_users.getEmail());
		preparedStatement.setString(2, signup_users.getFirstName());
		preparedStatement.setString(3, signup_users.getLastName());
		preparedStatement.setString(4, signup_users.getPassword());	
		preparedStatement.setString(5, signup_users.getrole());
	

         
        boolean rowUpdated = preparedStatement.executeUpdate() > 0;
        preparedStatement.close();
        return rowUpdated;     
    }
    
    public user getUser(String email) throws SQLException {
    	user user = null;
        String sql = "SELECT * FROM signup_users WHERE email = ?";
         
        connect_func();
         
        preparedStatement = (PreparedStatement) connect.prepareStatement(sql);
        preparedStatement.setString(1, email);
         
        ResultSet resultSet = preparedStatement.executeQuery();
         
        if (resultSet.next()) {
            String FirstName = resultSet.getString("FirstName");
            String LastName = resultSet.getString("LastName");
            String password = resultSet.getString("password");
            String role = resultSet.getString("role");


            user = new user(email, FirstName, LastName, password, role);
        }
         
        resultSet.close();
        statement.close();
         
        return user;
    }
    
    public boolean checkEmail(String email) throws SQLException {
    	boolean checks = false;
    	String sql = "SELECT * FROM signup_users WHERE email = ?";
    	connect_func();
    	preparedStatement = (PreparedStatement) connect.prepareStatement(sql);
        preparedStatement.setString(1, email);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        System.out.println(checks);	
        
        if (resultSet.next()) {
        	checks = true;
        }
        
        System.out.println(checks);
    	return checks;
    }
    
    public boolean checkPassword(String password) throws SQLException {
    	boolean checks = false;
    	String sql = "SELECT * FROM signup_users WHERE password = ?";
    	connect_func();
    	preparedStatement = (PreparedStatement) connect.prepareStatement(sql);
        preparedStatement.setString(1, password);
        ResultSet resultSet = preparedStatement.executeQuery();
        
        System.out.println(checks);	
        
        if (resultSet.next()) {
        	checks = true;
        }
        
        System.out.println(checks);
       	return checks;
    }
    
    
    
    public boolean isValid(String email, String password) throws SQLException
    {
    	String sql = "SELECT * FROM signup_users";
    	connect_func();
    	statement = (Statement) connect.createStatement();
    	ResultSet resultSet = statement.executeQuery(sql);
    	
    	resultSet.last();
    	
    	int setSize = resultSet.getRow();
    	resultSet.beforeFirst();
    	
    	for(int i = 0; i < setSize; i++)
    	{
    		resultSet.next();
    		if(resultSet.getString("email").equals(email) && resultSet.getString("password").equals(password)) {
    			return true;
    		}		
    	}
    	return false;
    }
    
    
    public void init() throws SQLException, FileNotFoundException, IOException{
    	connect_func();
        statement =  (Statement) connect.createStatement();
        
        String[] DATA_DELETION = {
					        "use testdb; ",
					        "delete from signup_users;",
					        "delete from users;",
					        "delete from quoterequests; ",
					        "delete from tree_details; ",
					        "delete from quoteresponses; ",
					        "delete from quotemodifications; ",
					        "delete from ordersaccepted; ",
					        "delete from billings;"
        					};
        
        String[] TUPLES_SIGNUP_USERS = {("insert into signup_users(email, password, FirstName, LastName, role) "+
        					"VALUES('root', 'pass1234', 'root', 'root', 'Admin root'),"
        					+ "    ('user1@gmail.com', 'password1', 'John', 'Doe', 'client'),"
        					+ "    ('user2@gmail.com', 'password2', 'Jane', 'Smith', 'client'),"
        					+ "    ('user3@gmail.com', 'password3', 'Robert', 'Johnson', 'client'),"
        					+ "    ('user4@gmail.com', 'password4', 'Alice', 'Wilson', 'client'),"
        					+ "    ('user5@gmail.com', 'password5', 'David', 'Lee', 'client'),"
        					+ "    ('user6@gmail.com', 'password6', 'Sarah', 'Brown', 'client'),"
        					+ "    ('user7@gmail.com', 'password7', 'Michael', 'Jones', 'client'),"
        					+ "    ('user8@gmail.com', 'password8', 'Emily', 'Davis', 'client'),"
        					+ "    ('user9@gmail.com', 'password9', 'William', 'Clark', 'client'),"
        					+ "    ('user10@gmail.com', 'password10', 'Olivia', 'Harris', 'client'),"
        					+ "    ('user11@gmail.com', 'password11', 'Will', 'Clark', 'client'),"
        					+ "    ('user12@gmail.com', 'password12', 'liam', 'Clark', 'client');"
			    			)};
        
        String[] TUPLES_USERS = {("insert into users(clientid, email, FirstName, LastName, Address, City, State, CreditCardDetails, PhoneNumber) "+
        							"VALUES ('1', 'user1@gmail.com', 'John', 'Doe', '123 Main St', 'City1', 'State1', '1111-2222-3333-4444', '5555555555'),"
        							+ "    ('2', 'user2@gmail.com', 'Jane', 'Smith', '456 Elm St', 'City2', 'State2', '2222-3333-4444-5555', '6666666666'),"
        							+ "    ('3', 'user3@gmail.com', 'Robert', 'Johnson', '789 Oak St', 'City3', 'State3', '3333-4444-5555-6666', '7777777777'),"
        							+ "    ('4', 'user4@gmail.com', 'Alice', 'Wilson', '101 Pine St', 'City4', 'State4', '4444-5555-6666-7777', '8888888888'),"
        							+ "    ('5', 'user5@gmail.com', 'David', 'Lee', '202 Birch St', 'City5', 'State5', '5555-6666-7777-8888', '9999999999'),"
        							+ "    ('6', 'user6@gmail.com', 'Sarah', 'Brown', '303 Cedar St', 'City6', 'State6', '6666-7777-8888-9999', '0000000000'),"
        							+ "    ('7', 'user7@gmail.com', 'Michael', 'Jones', '404 Redwood St', 'City7', 'State7', '7777-8888-9999-0000', '1111222233'),"
        							+ "    ('8', 'user8@gmail.com', 'Emily', 'Davis', '505 Walnut St', 'City8', 'State8', '8888-9999-0000-1111', '2222333344'),"
        							+ "    ('9', 'user9@gmail.com', 'William', 'Clark', '606 Maple St', 'City9', 'State9', '9999-0000-1111-2222', '3333444455'),"
        							+ "    ('10', 'user10@gmail.com', 'Olivia', 'Harris', '707 Ash St', 'City10', 'State10', '1234-5678-9012-3456', '4444555566'),"
        							+ "    ('11', 'user11@gmail.com', 'Olvia', 'Har', '707 Ash St', 'City11', 'State11', '1234-5678-9012-3456', '4446555566'),"
        							+ "    ('12', 'user12@gmail.com', 'Em', 'Das', '505 Walnut St', 'City12', 'State12', '8888-9999-0000-1111', '2221333344');"
        		)};
        
        String[] TUPLES_QuoteRequests = {("INSERT INTO QuoteRequests(requestid, clientid, NumberofTrees)"
        		+ "VALUES ('1', '1', '3'),"
        		+ "    ('2', '2', '4'),"
        		+ "    ('3', '3', '10'),"
        		+ "    ('4', '4', '6'),"
        		+ "    ('5', '5', '9'),"
        		+ "    ('6', '6', '35'),"
        		+ "    ('7', '7', '4'),"
        		+ "    ('8', '8', '1'),"
        		+ "    ('9', '9', '2'),"
        		+ "    ('10', '10', '3'),"
        		+ "    ('11','11','4'),"
        		+ "    ('12','12','5');"
				)};
        
        String[] TUPLES_Tree_details = {("INSERT INTO tree_details(requestid, size, height, location, NearHouse)"
        		+ "VALUES ('1', '40.2', '12.2', 'Tree near Entrance', False),"
        		+ "    ('2', '36.5', '28.2', '3rd tree on the way to the house', False),"
        		+ "    ('3', '18.1', '16.5', 'Tree near the house', True),"
        		+ "    ('4', '18.1', '16.3', '1st tree on the left', True),"
        		+ "    ('5', '12.1', '16.5', '2nd tree on the left', True),"
        		+ "    ('6', '11.1', '12.5', '1st tree on the right', False),"
        		+ "    ('7', '1.1', '18.5', '2nd tree on the right', False),"
        		+ "    ('8', '8.1', '16.5', '3rd tree on the right', False),"
        		+ "    ('9', '19.1', '6.5', '4th tree on the right', False),"
        		+ "    ('10', '68.1', '9.5', '4th tree on the right', False),"
        		+ "    ('11', '12.1', '9.9', '4th tree on the right', False),"
        		+ "    ('12', '18.2', '2.5', '4th tree on the right', False);"
				)};
        
        String[] TUPLES_QuoteResponses = {("insert into QuoteResponses(quoteid, requestid, clientid, status, InitialPrice, StartDate,EndDate,Note) "+
				"  values ('1', '1', '1', 'Accepted', '300', '2020-01-01', '2020-01-07', NULL),"
				+ "    ('2', '2', '2', 'Accepted', '400', '2020-01-08', '2020-01-15', NULL),"
				+ "    ('3', '3', '3', 'Rejected', NULL, NULL, NULL, 'The request is difficult to process'),"
				+ "    ('4', '4', '4', 'Accepted', '1300', '2021-01-01', '2020-01-07', NULL),"
				+ "    ('5', '5', '5', 'Rejected', NULL, NULL, NULL, 'Difficulty too high'),"
				+ "    ('6', '6', '6', 'Accepted', '700', '2020-03-01', '2020-03-07', NULL),"
				+ "    ('7', '7', '7', 'Accepted', '800', '2020-04-01', '2020-04-07', NULL),"
				+ "    ('8', '8', '8', 'Accepted', '300', '2020-05-01', '2020-05-07', NULL),"
				+ "    ('9', '9', '9', 'Accepted', '3500', '2020-06-01', '2020-06-07', NULL),"
				+ "    ('10', '10', '10', 'Accepted', '1300', '2020-06-15', '2020-06-16', NULL),"
				+ "    ('11', '11', '11', 'Accepted', '1300', '2020-06-15', '2020-06-16', NULL),"
				+ "    ('12', '12', '12', 'Accepted', '1300', '2020-06-15', '2020-06-16', NULL);"
				)};
        
        String[] TUPLES_QuoteModifications = {("insert into QuoteModifications(ResponseQuoteid, quoteid, InitialPrice, StartDate, EndDate, Note,status) "+
				"  VALUES ('1', '1', '200', '2020-01-01', '2020-01-07', NULL, 'Accepted'),"
				+ "    ('2', '2', '200', '2020-03-01', '2020-03-07', NULL, 'Accepted'),"
				+ "    ('3', '4', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),"
				+ "    ('4', '6', '700', '2021-01-05', '2021-03-02', 'Only works if you\\'re able to provide support during this time period', 'Accepted'),"
				+ "    ('5', '7', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),"
				+ "    ('6', '8', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),"
				+ "    ('7', '9', '800', '2020-03-01', '2020-03-07', NULL, 'Accepted'),"
				+ "    ('8', '10', '800', '2022-03-01', '2022-03-07', NULL, 'Accepted'),"
				+ "    ('9', '11', '800', '2022-03-01', '2022-03-07', NULL, 'Accepted'),"
				+ "    ('10', '12', NULL, NULL, NULL, 'Price too high', 'Accepted');"
				)};
        
        String[] TUPLES_OrdersAccepted = {("insert into OrdersAccepted(orderid, clientid, requestid, AcceptedQuoteid) "+
				"   values ('1', '1', '1', '1'),"
				+ "    ('2', '2', '2', '2'),"
				+ "    ('3', '4', '4', '4'),"
				+ "    ('4', '6', '6', '6'),"
				+ "    ('5', '7', '7', '7'),"
				+ "    ('6', '8', '8', '8'),"
				+ "    ('7', '9', '9', '9'),"
				+ "    ('8', '10', '10', '10'),"
				+ "    ('9', '11', '11', '11'),"
				+ "    ('10', '12', '12', '12');"
				)};
        
        String[] TUPLES_Billings = {("insert into Billings(Billid, orderid, TotalAmount, status, note) "+
				"	values ('1', '1', '200', 'Received', NULL),"
				+ "    ('2', '2', '300', 'Pending', 'Will pay in 2 weeks'),"
				+ "    ('3', '3', '400', 'Received', NULL),"
				+ "    ('4', '4', '600', 'Received', NULL),"
				+ "    ('5', '5', '700', 'Received', NULL),"
				+ "    ('6', '6', '800', 'Received', NULL),"
				+ "    ('7', '7', '1250', 'Received', NULL),"
				+ "    ('8', '8', '1150', 'Received', 'Great work!'),"
				+ "    ('9', '9', '1900', 'Pending', 'Unsatisfactory work'),"
				+ "    ('10', '10', '150', 'Pending', 'Work not completed yet');"
				)};
        
        
        //for loop to put these in database
        for (int i = 0; i < DATA_DELETION.length; i++)
        	statement.execute(DATA_DELETION[i]);
        
        for (int i = 0; i < TUPLES_SIGNUP_USERS.length; i++)	
        	statement.execute(TUPLES_SIGNUP_USERS[i]);
        
        for (int i = 0; i < TUPLES_USERS.length; i++)	
        	statement.execute(TUPLES_USERS[i]);
        
        for (int i = 0; i < TUPLES_QuoteRequests.length; i++)	
        	statement.execute(TUPLES_QuoteRequests[i]);

        for (int i = 0; i < TUPLES_Tree_details.length; i++)	
        	statement.execute(TUPLES_Tree_details[i]);
        
        for (int i = 0; i < TUPLES_QuoteResponses.length; i++)	
        	statement.execute(TUPLES_QuoteResponses[i]);
        
        for (int i = 0; i < TUPLES_QuoteModifications.length; i++)	
        	statement.execute(TUPLES_QuoteModifications[i]);
        
        for (int i = 0; i < TUPLES_OrdersAccepted.length; i++)	
        	statement.execute(TUPLES_OrdersAccepted[i]);
        
        for (int i = 0; i < TUPLES_Billings.length; i++)	
        	statement.execute(TUPLES_Billings[i]);
        disconnect(); 
    }

}
