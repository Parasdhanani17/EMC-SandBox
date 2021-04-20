import { ShowToastEvent } from 'lightning/platformShowToastEvent';


const showMessage = (page, t, m,type ) => {
    const toastEvt = new ShowToastEvent({
        title: t,
        message:m,
        variant: type
    });
    page.dispatchEvent(toastEvt);
};

const isValidForm = (elements) => {
        var isFormValid=true;
        const allValid = elements.reduce((validSoFar, inputCmp) => {
                    inputCmp.reportValidity();
                    return validSoFar && inputCmp.checkValidity();
        }, true);
        if (!allValid) {
            isFormValid=false;
        }
        return isFormValid;
};

const formatData = (data) => {
    var  tripData = [];
    data.forEach((row) => {
        var dayOfWeek;
        let rowData = {};
        let formatDate = fullDateFormat(row);
        let userDate = dateFormat(row);
        if (row.Day_Of_Week__c != undefined) {
            dayOfWeek = row.Day_Of_Week__c.toString().slice(0, 3);
        } else {
            dayOfWeek = "";
            dayOfWeek = dayOfWeek.toString();
        }
        let strTime = TimeFormat(row.ConvertedStartTime__c);
        let enTime = TimeFormat(row.ConvertedEndTime__c);
        rowData.id = row.Id;
        rowData.TripId = row.Trip_Id__c;
        rowData.Mileage = (row.Mileage__c === undefined) ? '' : row.Mileage__c.toString();
        rowData.TripOrigin = row.Trip_Origin__c;
        rowData.TripDestination = row.Trip_Destination__c;
        if (row.Trip_Destination__c != undefined) {
          let getState = validateState(row.Trip_Destination__c);
          rowData.State = getState.slice(0, 2);
        }
        rowData.TriplogMap = row.Triplog_Map__c;
        rowData.TimeZone = row.TimeZone__c;
        rowData.TripStatus = row.Trip_Status__c;
        if (row.Way_Points__c != undefined) {
          rowData.waypoint = row.Way_Points__c;
        }
  
        rowData.TrackingMethod = row.Tracing_Style__c;
        rowData.FromLocation = row.Origin_Name__c;
        rowData.ToLocation = row.Destination_Name__c;
        rowData.Day = dayOfWeek;
        rowData.userdate = userDate.toString();
        rowData.StartTime = strTime.toString();
        rowData.EndTime = enTime.toString();
        rowData.Date = formatDate.toString();
        rowData.Time =
          enTime === "" ?
          strTime.toString() :
          strTime === "" ?
          enTime.toString() :
          strTime.toString() + " " + "-" + " " + enTime.toString();
        rowData.Tags = (row.Tag__c === undefined) ? '' : row.Tag__c;
        rowData.notes = (row.Notes__c === undefined) ? '' : row.Notes__c; 
        rowData.DriveTime = (row.Driving_Time__c === undefined) ? '' : row.Driving_Time__c;
        rowData.StayTime = (row.Stay_Time__c === undefined) ? '' : row.Stay_Time__c;
        rowData.TotalTime = (row.Drive_Stay_Time__c === undefined) ? '' : row.Drive_Stay_Time__c;
        rowData.FromLatitude = row.From_Location__Latitude__s;
        rowData.FromLongitude = row.From_Location__Longitude__s;
        rowData.ToLatitude = row.To_Location__Latitude__s;
        rowData.ToLongitude = row.To_Location__Longitude__s;
  
        if (row.EmployeeReimbursement__r) {
          rowData.TripLogApi = row.EmployeeReimbursement__r.Contact_Id__r.Account.Triplog_API__c;
          if (
            row.EmployeeReimbursement__r.Contact_Id__r.External_Email__c === undefined
          ) {
            rowData.emailID = '';
          } else {
            rowData.emailID =
              row.EmployeeReimbursement__r.Contact_Id__r.External_Email__c;
          }
        }
        if (row.EmployeeReimbursement__c) {
          rowData.Name = row.EmployeeReimbursement__r.Contact_Id_Name__c;
          rowData.VehicleType =
            row.EmployeeReimbursement__r.Contact_Id__r.Vehicle_Type__c;
        }
  
        tripData.push(rowData);
      });

      return tripData;
}

const excelData = (exlData) => {
   var exportData = {};
   exportData.Driver = exlData.Name,
   exportData.Email = exlData.emailID,
   exportData.Status = exlData.TripStatus,
   exportData.Date = exlData.userdate,
   exportData.Day = exlData.Day,
   exportData.StartTime = exlData.StartTime,
   exportData.EndTime = exlData.EndTime,
   exportData.StayTime = exlData.StayTime,
   exportData.DriveTime = exlData.DriveTime,
   exportData.TotalTime = exlData.TotalTime,
   exportData.Activity = "Business",
   exportData.Mileage = exlData.Mileage,
   exportData.FromLocationName = exlData.FromLocation,
   exportData.FromLocationAddress = exlData.TripOrigin,
   exportData.ToLocationName = exlData.ToLocation,
   exportData.ToLocationAddress = exlData.TripDestination,
   exportData.State = exlData.State,
   exportData.Tags = exlData.Tags,
   exportData.Notes = exlData.notes,
   exportData.TrackingMethod = exlData.TrackingMethod
  return exportData;
}
const changeKeyObjects = (csvData) => {
  var filterCSVData = [];
  csvData.forEach((excel) => {
  var replaceKey = {};
  replaceKey["Driver"] = excel.Name;
  replaceKey["Email"] = excel.emailID;
  replaceKey["Status"] = excel.TripStatus;
  replaceKey["Date"] = excel.userdate;
  replaceKey["Day"] = excel.Day;
  replaceKey["Start Time"] = excel.StartTime;
  replaceKey["End Time"] = excel.EndTime;
  replaceKey["Stay Time"] = excel.StayTime;
  replaceKey["Drive Time"] = excel.DriveTime;
  replaceKey["Total Time"] = excel.TotalTime;
  replaceKey["Activity"] = "Business";
  replaceKey["Mileage (mi)"] = excel.Mileage;
  replaceKey["From Location Name"] = excel.FromLocation;
  replaceKey["From Location Address"] = excel.TripOrigin;
  replaceKey["To Location Name"] = excel.ToLocation;
  replaceKey["To Location Address"] = excel.TripDestination;
  replaceKey["State"] = excel.State;
  replaceKey["Tags"] = excel.Tags;
  replaceKey["Notes"] = excel.notes;
  replaceKey["Tracking Method"] = excel.TrackingMethod;
  filterCSVData.push(replaceKey);

  });

  return filterCSVData;
}
const excelFormatDate =(exlDate)=>{
  var today = new Date(exlDate);
  var dd = String(today.getDate()).padStart(2, '0');
  var mm = String(today.getMonth() + 1).padStart(2, '0'); //January is 0!
  var yyyy = today.getFullYear();

  today = yyyy + '-' + mm + '-' + dd;
  return today;
}
const validateDate=(dob)=>{
  var filterDate = dob;
  var date = new Date(filterDate);
  var dd = date.getDate();
  var mm = date.getMonth() + 1;
  var yy = date.getFullYear();
  var dateModified = mm + "/" + dd + "/" + yy;
  return dateModified;
}
   // function to format date with week day
  const fullDateFormat=(rowObj) => {
    if (rowObj.ConvertedStartTime__c != undefined) {
      let newdate = new Date(rowObj.ConvertedStartTime__c);
      let dayofweek;
      let dd = newdate.getDate();
      let mm = newdate.getMonth() + 1;
      let yy = newdate.getFullYear();
      if (rowObj.Day_Of_Week__c != undefined) {
        dayofweek = rowObj.Day_Of_Week__c.toString().slice(0, 3);
      } else {
        dayofweek = "";
        dayofweek = dayofweek.toString();
      }
      return mm + "/" + ("0" + dd).slice(-2) + "/" + yy + " " + dayofweek;
    } else {
      return "";
    }
  }
  // function to format date
  const dateFormat = (rowObj) => {
    if (rowObj.ConvertedStartTime__c != undefined) {
      let newdate = new Date(rowObj.ConvertedStartTime__c);
      let dd = newdate.getDate();
      let mm = newdate.getMonth() + 1;
      let yy = newdate.getFullYear();

      return mm + "/" + dd + "/" + yy;
    } else {
      return "";
    }
  }

    // function to format time
    const TimeFormat = (timeObj) => {
      if (timeObj != undefined) {
        let startendTime = new Date(timeObj);
        let convertedTime = startendTime.toLocaleTimeString("en-US", {
          timeZone: "America/Panama",
          hour: "2-digit",
          minute: "2-digit",
        });
        return convertedTime;
      } else {
        return "";
      }
    }

    const validateState = (stateVal) => {
      var regDigit = /\b\d{5}\b/g,
        tripSate, bool;
      bool = /^[0-9,-.]*$/.test(stateVal);
      if (!bool) {
        let state = stateVal;
        let digit = state.slice(-5);
        if (digit.match(regDigit)) {
          tripSate = stateVal.slice(-9);
        } else {
          tripSate = '';
        }
      } else {
        tripSate = '';
      }
  
      return tripSate;
    }

export 
{
    showMessage,
    isValidForm,
    excelData,
    validateDate,
    formatData, 
    excelFormatDate,
    changeKeyObjects
}