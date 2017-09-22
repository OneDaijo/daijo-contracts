node {
    stage "Create build output"
    
    // Make the output directory.
    sh "mkdir -p output"

    sh "nohup testrpc &"

    sh "sleep 5"

    def status = sh returnStatus: true, script: "truffle test &> output/test_output.txt"

    // Write an useful file, which is needed to be archived.
    writeFile file: "output/usefulfile.txt", text: "This file is useful, need to archive it."

    stage "Archive build output"
    
    // Archive the build output artifacts.
    archiveArtifacts artifacts: 'output/*.txt'

    sh "rm -rf output"

    assert status == 0 
}
