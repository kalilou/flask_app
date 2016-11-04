FROM centos:7
MAINTAINER Kalilou Diaby kalilou1988@gmail.com

# Yum workaround to stalled mirror
RUN sed -i -e 's/enabled=1/enabled=0/g' /etc/yum/pluginconf.d/fastestmirror.conf

RUN rm -f /var/lib/rpm/__*
RUN rpm --rebuilddb -v -v
RUN yum clean all

RUN yum install -y epel-release 
RUN yum clean all

RUN yum install -y python-pip python-devel
RUN pip install -U pip


# We copy just the requirements.txt first to leverage Docker cache
COPY ./requirements.txt /flask_app/requirements.txt

WORKDIR /flask_app

RUN pip install -r requirements.txt

COPY . /flask_app


EXPOSE 5000 


ENTRYPOINT [ "python" ]

CMD [ "app.py" ]