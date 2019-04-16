function ReplaceUndefined(stringVariable){
	if(stringVariable==undefined){
		return "";
	}
	else if(stringVariable==null){
		return "";	
	}
	else
	{
		return stringVariable;
	}
};

function LimitLength(stringVariable, length){
	if(stringVariable.length>length){
		stringVariable=stringVariable.substring(0,length);	
	}
	return stringVariable;
};

function WideSearch(searchString,divResults){
	$.ajax({
		type: "POST",
		url: "index.php",
		data: "doThis=WideSearch&searchString="+searchString,
		error: function (msg){
			$("#spanStatus").text(msg);
		},
		failure: function (msg){
			$("#spanStatus").text(msg);
		},
		success: function (msg){
			var result=JSON.parse(msg);
			var htmlToCreate="";
			$.each(result,function(rbr, resultRow){
				if(resultRow.contact==null){
					htmlToCreate=htmlToCreate+"<div class='customerList'>"+ReplaceUndefined(resultRow.customer)+" "+ReplaceUndefined(resultRow.name)+" "+LimitLength(ReplaceUndefined(resultRow.description),50)+"</div><br />";
				}
				else{
					htmlToCreate=htmlToCreate+"<div class='contactList'>"+ReplaceUndefined(resultRow.contact) +" "+ReplaceUndefined(resultRow.firstName)+" "+ReplaceUndefined(resultRow.lastName)+" "+LimitLength(ReplaceUndefined(resultRow.description),50)+"</div><br />";
				}
			});
			$("#"+divResults).html(htmlToCreate);
		}
	});	
}

function ajaxCustomersSearch(searchString){
	return $.ajax({
		type: "POST",
		url: "customers.php",
		data: "doThis=CustomersSearch&searchString="+searchString
	});
};

function CustomersSearch(searchString,divResults){
	$.ajax({
		type: "POST",
		url: "customers.php",
		data: "doThis=CustomersSearch&searchString="+searchString
	}).done(function(msg){
			var result=JSON.parse(msg);
			var htmlToCreate="";
			$.each(result,function(rbr, resultRow){
				htmlToCreate=htmlToCreate+"<div class='customerList'><div class='customerListData' id='customer_"+resultRow.customer+"'><input id='id_"+resultRow.customer+"' type='hidden' value='"+resultRow.customer+"' />"+ReplaceUndefined(resultRow.name)+" "+LimitLength(ReplaceUndefined(resultRow.description),40)+"</div><div class='customerListDelete' id='deleteCustomer_"+resultRow.customer+"'>DELETE</div></div>";
			});
			$("#"+divResults).html(htmlToCreate);
	});
}


function LoggedIn(){
	$.ajax({
		type: "POST",
		url: "login.php",
		data: "doThis=IsLogged",
		error: function (msg){
			$("#spanStatus").text(msg);
		},
		failure: function (msg){
			$("#spanStatus").text(msg);
		},
		success: function (msg){
			if (msg.indexOf("Success")!=-1){
				message=msg.replace("Success: ","");
				$("#LoggedIn").text(message);
			}
			else
			{
				window.location.replace("login.html");	
			}
		}
	});
}

function MenuTopClick(clicked){
		switch(clicked){
			case "LogOut":
				$.ajax({
					type: "POST",
					url: "login.php",
					data: "doThis=LogOut",
					error: function (msg){
						window.location.replace("login.html");	
					},
					failure: function (msg){
						window.location.replace("login.html");	
					},
					success: function (msg){
						window.location.replace("login.html");	
					}
				})	
				break;	
			case "Customers":
				window.location.replace("customers.html");
				break;
			case "PaS":
				window.location.replace("pas.html");
				break;
			case "Home":
				window.location.replace("index.html");
				break;
			case "Contacts":
				window.location.replace("contacts.html");
				break;
		};
}

$.fn.serializeForm = function (filter) {
            var selected = $("#"+this[0].id+" input,#"+this[0].id+" select");
            var tempSerial = selected.serialize();
            return tempSerial;
};

function CreateViewDIV(dataset, name, description, id){
	var htmlToReturn="";
	htmlToReturn="<div class='viewDIVFirst' id='"+name+"'>"+description+"</div>";
	$.each(dataset,function(key, value){
		htmlToReturn=htmlToReturn+"<div class='viewDIV' style='display:none' id='"+name+"_"+value[id]+"'>";
		$.each(value,function(key2, value2){
			if (key2!==id){
				htmlToReturn=htmlToReturn+value2+" ";	
			}
		});
		htmlToReturn=htmlToReturn+"</div>"
	});
	htmlToReturn=htmlToReturn+"</div>"
	return htmlToReturn;
};

function CreateVerticalTable(dataset,description,tableClass){
	var htmlToReturn="";
	var emptyData=dataset.length;
	if (emptyData===0) emptyData=true;
	else emptyData=false;
	var tempText="";
	$.each(description, function(key, value){
		$.each(value, function(key2, value2){
			switch (key2){
				case "inputhidden":
					var elementClass="";
					var idPrefix="";
					var itemName="";
					$.each(value2, function(key3,value3){
						switch (key3){
							case "idPrefix":
								idPrefix=value3;
								break;
							case "elementClass":
								elementClass=value3;
								break;
						}
					});
					if(emptyData) {
						tempText="";	
					}
					else
					{
						tempText=ReplaceUndefined(dataset[0][key])	
					}
					htmlToReturn=htmlToReturn+"<input type='hidden' value = '"+tempText+"' id='"+idPrefix+key+"' name='"+key+"' class='"+elementClass+"' />";
					break;
				case "inputtext":
					var elementClass="";
					var idPrefix="";
					var maxLength="";
					$.each(value2, function(key3,value3){
						switch (key3){
							case "idPrefix":
								idPrefix=value3;
								break;
							case "elementClass":
								elementClass=value3;
								break;
							case "maxLength":
								maxLength=" maxlength='"+value3+"'"
						}
					});
					if(emptyData) {
						tempText="";	
					}
					else
					{
						tempText=ReplaceUndefined(dataset[0][key])	
					}
					htmlToReturn=htmlToReturn+"<input type='text' style='display:none' value = '"+tempText+"' id='"+idPrefix+key+"' name='"+key+"' class=class='"+elementClass+"' "+maxLength+"/>";
					break;
				case "span":
					var elementClass="";
					var idPrefix="";
					$.each(value2, function(key3,value3){
						switch (key3){
							case "idPrefix":
								idPrefix=value3;
								break;
							case "elementClass":
								elementClass=value3;
								break;
						}
					});
					if(emptyData) {
						tempText="";	
					}
					else
					{
						tempText=ReplaceUndefined(dataset[0][key])	
					}
					htmlToReturn=htmlToReturn+"<span class='"+elementClass+"' id='"+idPrefix+key+"'>"+tempText+"</span>";
					break;
				case "selectControl":

					var idPrefix="";
					var elementClass="";
					var dataSource="";
					additionalLine=""
					$.each(value2, function(key3,value3){
						switch (key3){
							case "idPrefix":
								idPrefix=value3;
								break;
							case "elementClass":
								elementClass=value3;
								break;
							case "dataSource":
								dataSource=value3;
								break;
							case "additionalLine":
								additionalLine="<option value=0>"+value3+"</option>"
						}
					});
					htmlToReturn=htmlToReturn+"<select class='"+elementClass+"' style='display:none' id='"+idPrefix+key+"' name='"+key+"'>"+additionalLine+dataSource+"</select>";
					break;
				case "legend":
					if(htmlToReturn==""){
						htmlToReturn="<table class='"+tableClass+"'><tr><td>";
					}else{
						if(htmlToReturn.indexOf("<table")!==-1){
							htmlToReturn=htmlToReturn+"</td></tr><tr><td class='"+tableClass+"'>";
						}else{
							htmlToReturn="<table class='"+tableClass+"'><tr><td class='"+tableClass+"'>"+htmlToReturn;
						};
					};
					var legendText="";
					var elementClass="";
					$.each(value2, function(key3,value3){
						switch (key3){
							case "legendText":
								legendText=value3;
								break;
							case "elementClass":
								elementClass=value3;
								break;
						}
					});
					htmlToReturn=htmlToReturn+"<legend class='"+elementClass+"'>"+legendText+"</legend></td><td class='"+tableClass+"'>";
					break;
				case "inputradio":
					var idPrefix="";
					var elementClass="";
					var data="";
					$.each(value2, function(key3,value3){
						switch (key3){
							case "idPrefix":
								idPrefix=value3;
								break;
							case "elementClass":
								elementClass=value3;
								break;
							case "data":
								data=value3;
								break;
						};
					});
					$.each(data, function(key7,value7){
						var checked="";
						if(emptyData) {
							tempText="";	
						}
						else
						{
							var tempValue=dataset[0][key];	
						}
						
						if (value7.value==tempValue) checked=" checked ";
						htmlToReturn=htmlToReturn+"<input type='radio' name='"+key+"' id='"+idPrefix+key+"' disabled value='"+value7.value+"'"+checked+"class='"+elementClass+" radio' /><span class='"+elementClass+"'>"+value7.description+"</span><br />";
						
					});
					break;
			};
		});
	});
	return htmlToReturn+"</td></tr></table>";	
};

function TurnCollectionIntoOptions(input){
	var htmlToCreate=""
	$.each(input,function(rbr, resultRow){
		htmlToCreate=htmlToCreate+"<option class='formElement' value='"+resultRow.id+"'>"+resultRow.name+"</option>";
	});
	return htmlToCreate;
}