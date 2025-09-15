#use nginx alpine as the baseline image for the Docker container
FROM nginx:alpine 
#copy the web server html code to the default directory nginx uses for html
COPY index.html /usr/share/nginx/html/
#allow incoming connections to the web server on port 80
EXPOSE 80
#start the Nginx server as the main process and keep it running in the foreground
CMD ["nginx", "-g", "daemon off;"]