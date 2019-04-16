// JavaScript Document

//Related to customers
function GetCustomersShortAll(){
	return $.ajax({
			type: "POST",
			url: "customers.php",
			data: "doThis=GetCustomersShortAll"});
};

function GetOrganizationsShortAll(){
	return	$.ajax({
			type: "POST",
			url: "customers.php",
			data: "doThis=GetOrganizationsShortAll"});
};

function GetChildCustomers(customer){
	return $.ajax({
			type: "POST",
			url: "customers.php",
			data: "doThis=GetChildCustomers&customer="+customer
		});
};

function GetPASContent(pas){
	return $.ajax({
			type: "POST",
			url: "pas.php",
			data: "doThis=GetPASContent&pas="+pas
		});
};

function GetPASContainedIn(pas){
	return $.ajax({
			type: "POST",
			url: "pas.php",
			data: "doThis=GetPASContainedIn&pas="+pas
		});
};

function SaveCustomer(data){
	return $.ajax({
			type: "POST",
			url: "customers.php",
			data: "doThis=SaveCustomer&"+data
		});
};

function SavePAS(data){
	return $.ajax({
			type: "POST",
			url: "pas.php",
			data: "doThis=SavePAS&"+data
		});
};

function SavePASContent(data){
	return $.ajax({
			type: "POST",
			url: "pas.php",
			data: "doThis=SavePASContent&data="+data
		});
};

function DeletePAS(pas){
	return $.ajax({
			type: "POST",
			url: "pas.php",
			data: "doThis=DeletePAS&pas="+pas
		});
};

function DeleteCustomer(customer){
	return $.ajax({
			type: "POST",
			url: "customers.php",
			data: "doThis=DeleteCustomer&customer="+customer
		});
};

function DeleteContact(customer){
	return $.ajax({
			type: "POST",
			url: "contacts.php",
			data: "doThis=DeleteContact&contact="+customer
		});
};

function GetContactByCustomer(customer){
	return $.ajax({
			type: "POST",
			url: "customers.php",
			data: "doThis=GetContactByCustomer&customer="+customer
		});
};

function GetCustomer(customer){
	return $.ajax({
		type: "POST",
		url: "customers.php",
		data: "doThis=GetCustomer&customer="+customer
		});
};

function GetContact(contact){
	return $.ajax({
		type: "POST",
		url: "contacts.php",
		data: "doThis=GetContact&contact="+contact
		});
};

function GetContactsSales(contact){
	return $.ajax({
		type: "POST",
		url: "contacts.php",
		data: "doThis=GetContactsSales&contact="+contact
		});
};
function GetPAS(pas){
	return $.ajax({
		type: "POST",
		url: "pas.php",
		data: "doThis=GetPAS&pas="+pas
		});
};

function GetSales(sales,contact,customer){
	return $.ajax({
		type: "POST",
		url: "pas.php",
		data: "doThis=GetSales&sales="+sales+"&contact="+contact+"&customer="+customer
		});
};

function GetSalesStatus(){
	return $.ajax({
		type: "POST",
		url: "pas.php",
		data: "doThis=GetSalesStatus"});
};

function SaveContact(data){
	return $.ajax({
			type: "POST",
			url: "contacts.php",
			data: "doThis=SaveContact&"+data
		});
};

function ajaxContactsSearch(searchString){
	return $.ajax({
		type: "POST",
		url: "contacts.php",
		data: "doThis=ContactsSearch&searchString="+searchString
	});
};

function ajaxPASSearch(searchString){
	return $.ajax({
		type: "POST",
		url: "pas.php",
		data: "doThis=PASSearch&searchString="+searchString
	});
};