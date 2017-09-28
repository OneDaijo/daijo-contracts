node {
    stage "Simple build and test"

    // Checkout the PR
    checkout scm

    // Must be installed locally
    sh "npm install web3@0.20.1"
    
    // Make the output directory.
    sh "mkdir -p output"

    // Ensure testrpc is running
    // This is a little hacky right now.  testrpc just fails if there's already one running.
    sh "nohup testrpc --gasLimit 471238801 &"

    // Give testrpc time to start up.
    sh "sleep 5"

    // Run linter
    sh "solium --dir ."

    // Get status but save as to not break early
    sh "truffle test"

    // Archive stages need some work
    // stage "Archive build output"
    
    // Archive the build output artifacts.
    // archiveArtifacts artifacts: 'build/*'

    // sh "rm -rf build"
}
