module.exports = {
	networks: {
    	development: {
      		host: "localhost",
      		port: 8545,
      		network_id: "*", // Match any network id
    	},
        test: {
            host: "localhost",
            port: 8545,
            network_id: "*", // Match any network id
            gas: 471238800,
        }
  	},
        mocha: {
            timeout: 300
        }
};
