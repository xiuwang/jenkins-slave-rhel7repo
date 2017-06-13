# The FROM will be replaced when building in OpenShift
FROM openshift/base-rhel7

# Install headless Java
USER root
#RUN export INSTALL_PKGS="java-1.8.0-openjdk nss_wrapper" && \
    #yum-config-manager --enable oso-rhui-rhel-server-releases && \
#RUN yum-config-manager --disable rhel-7-server-nfv-rpms && \
RUN INSTALL_PKGS="nss_wrapper java-1.8.0-openjdk" &&   \
    yum-config-manager --enable rhel-server-rhscl-7-rpms && \    
    yum-config-manager --disable epel >/dev/null || : && \
   # yum install -y --enablerepo=rhel-7-server-ose-3.1-rpms $INSTALL_PKGS && \
    yum install -y $INSTALL_PKGS && \
    rpm -V $INSTALL_PKGS && \
    yum clean all
RUN mkdir -p /home/jenkins && \
    chown -R 1001:0 /home/jenkins && \
    chmod -R g+w /home/jenkins

# Copy the entrypoint
ADD contrib/openshift/* /usr/local/bin/
USER 1001

# Run the Jenkins JNLP client
ENTRYPOINT ["/usr/local/bin/run-jnlp-client"]
