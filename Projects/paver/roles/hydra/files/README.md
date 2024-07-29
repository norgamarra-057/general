To generate hydra package clone gds-hydra reopsitory and build it:

    git clone git@github.groupondev.com:gds/gds-hydra.git
    mvn package -P assembler,release -f hydra/java/pom.xml
    cp hydra/java/main/target/dist/hydra-*.tar.gz . 
