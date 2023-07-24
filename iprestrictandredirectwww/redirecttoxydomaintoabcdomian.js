'use strict';
exports.handler = (event, context, callback) => {

  console.log('Lambda triggered for "xyz.com"'); // current domain name

  const request = event.Records[0].cf.request;
  console.log(request);

  //Some browser send host as Host  
  var hostName = request.headers.host ? request.headers.host[0].value : request.headers.Host[0].value
  
  if (hostName.indexOf("xyz.com")>=0){  // current domain name
    var updatedHostName = hostName.replace("xyz.com","abc.com"); // current to new domain name
    var location = "https://" + updatedHostName + request.uri;
    const response = {
    status: '302',
    statusDescription: '302 Found',
    headers: {
            location: [{
                key: 'Location',
                value: location,
            }],
        }
   };
   console.log(response);
   
   callback(null, response);
  } else {
    console.log("no redirect required");
    callback(null, request);
    return;
  }
};