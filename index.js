exports.handler = async (event, context) => {
    // Print the event to the console
    console.log("Received event:", JSON.stringify(event, null, 2));
    
    // Return the event as the response
    return {
        statusCode: 200,
        body: JSON.stringify({
            message: 'Event received',
            event: event
        })
    };
};
