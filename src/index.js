exports.handler = async (event) => {
  return {
    statusCode: 200,
    body: 'foobar'
  };
};

// exports.handler = async (event) => {
//     // TODO implement
//     const response = {
//         statusCode: 200,
//         body: JSON.stringify('Hello from Lambda!'),
//     };
//     return response;
// };
