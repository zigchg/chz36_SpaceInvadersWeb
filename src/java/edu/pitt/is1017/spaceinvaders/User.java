package edu.pitt.is1017.spaceinvaders;

import java.sql.ResultSet;
import java.sql.SQLException;
import javax.swing.JOptionPane;

//import javax.swing.JOptionPane;

public class User {
	private int userID;
	private String lastName;
	private String firstName;
	private String email;
	private String password;
	private boolean loggedIn = false;
	
	public User (int userID) throws SQLException{
		String sql = "SELECT * FROM users WHERE userID = " + userID + ";";
		//System.out.println(sql);
		DbUtilities dbu = new DbUtilities();
		ResultSet rs = dbu.getResultSet(sql);
		if (rs.next()){
			this.userID = rs.getInt(1);
			this.lastName = rs.getString(2);
			this.firstName = rs.getString(3);
			this.email = rs.getString(4);
			this.password = rs.getString(5);
		}
		dbu.closeConnection();
	}
	
	public User (String email, String password) throws SQLException {
		String sql = "SELECT * FROM users WHERE email = '" + email + "' and password = MD5('"
				+ password + "');";
		//System.out.println(sql);
		DbUtilities dbu = new DbUtilities();
		ResultSet rs = dbu.getResultSet(sql);
		if (rs.next()){
			this.userID = rs.getInt(1);
			this.lastName = rs.getString(2);
			this.firstName = rs.getString(3);
			this.email = rs.getString(4);
			this.password = rs.getString(5);
			this.loggedIn = true;
			//JOptionPane.showMessageDialog(null, "Login Verification Successed");
                        
		}
		else {
			this.loggedIn = false;
			//JOptionPane.showMessageDialog(null, "Login Verification Failed");
		}
		dbu.closeConnection();
	}
	
	public User (String lastName, String firstName, String email, String password){
		this.lastName=lastName;
		this.firstName=firstName;
		this.email=email;
		this.password=password;
		String sql = "INSERT INTO alieninvasion.users (lastName,firstName, email, password) "
				+ "VALUE ('" + lastName + "', '"+ firstName +"', '"+ email +"', MD5('"
				+ password + "'));";
		//System.out.println (sql);
		DbUtilities dbu = new DbUtilities();
                dbu.executeQuery(sql);
                /*
		if (dbu.executeQuery(sql)) {
			//JOptionPane.showMessageDialog(null, "Registeration Successed");
		}
		else {
			//JOptionPane.showMessageDialog(null, "Registeration Failed");
		}
                **/
		dbu.closeConnection();
	}
	
	public void saveUserInfo(){
		String sql = "UPDATE users SET "
				+ "lastName = '" + this.lastName + "', firstName = '" + this.firstName + "', "
						+ "email = '" + this.email + "', password = MD5('" + this.password+ "') "
								+ "WHERE userID=" + this.userID + ";";
		DbUtilities dbu = new DbUtilities();
                dbu.executeQuery(sql);
                /*
		if (dbu.executeQuery(sql)){
			//JOptionPane.showMessageDialog(null, "Update Successed");
		}
		else {
			//JOptionPane.showMessageDialog(null, "Update Failed");
		}
                **/
		dbu.closeConnection();

	}

	public String getLastName() {
		return lastName;
	}

	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public String getFirstName() {
		return firstName;
	}

	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getEmail() {
		return email;
	}

	public void setEmail(String email) {
		this.email = email;
	}

	public String getPassword() {
		return password;
	}

	public void setPassword(String password) {
		this.password = password;
	}

	public boolean isLoggedIn() {
		return loggedIn;
	}

	public void setLoggedIn(boolean loggedIn) {
		this.loggedIn = loggedIn;
	}

	public int getUserID() {
		return userID;
	}
}
