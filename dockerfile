# Use an official Nginx image to serve your site
FROM nginx

# Copy the website files to the Nginx web root directory
COPY . /usr/share/nginx/html

# Expose port 80 so the container can be accessed from a browser
EXPOSE 80
