<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
 <%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
 
<!DOCTYPE html>
<html>
<head>
<meta charset="ISO-8859-1">
<title>Root page</title>
</head>
<body>

<div align = "center">
	
	<form action = "initialize">
		<input type = "submit" value = "Initialize the Database"/>
	</form>
	<a href="login.jsp"target ="_self" > logout</a><br><br> 

<h1>List all users</h1>
    <div align="center">
        <table border="1" cellpadding="6">
            <caption><h2>List of Users</h2></caption>
            <tr>
                <th>Email</th>
                <th>First name</th>
                <th>Last name</th>
                <th>Password</th>
                <th>Role</th>

            </tr>
            <c:forEach var="signup_users" items="${listUser}">
                <tr style="text-align:center">
                    <td><c:out value="${signup_users.email}" /></td>
                    <td><c:out value="${signup_users.firstName}" /></td>
                    <td><c:out value="${signup_users.lastName}" /></td>
                    <td><c:out value="${signup_users.password}" /></td>
                    <td><c:out value="${signup_users.role}" /></td>

            </c:forEach>
        </table>
	</div>
	</div>

</body>
</html>