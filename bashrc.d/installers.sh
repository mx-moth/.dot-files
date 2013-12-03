# Installers/downloaders/etc for various tools


# Download and unzip the latest release of bootstrap.
#
# Usage: get::bootstrap [destination-directory]
#
# Example:
#
#     $ bootstrap-me static/libs/bootstrap
#     $ ls static/libs/bootstrap
#     css/ fonts/ js/
function install.bootstrap() {
	destination="${1:-.}"
	tmpdir=$( mktemp -d )

	owner='twbs'
	repo='bootstrap'

	tag_json=$( curl -s "https://api.github.com/repos/$owner/$repo/tags" \
		| json -c 'this.name.match(/^v\d+\.\d+\.\d+$/)' 0 )

	tag_sha=$( echo "$tag_json" | json commit.sha )
	tag_tarball=$( echo "$tag_json" | json tarball_url )

	mkdir -p -- "$destination"
	dirname="twbs-bootstrap-${tag_sha:0:7}"
	curl -sL# "$tag_tarball" | tar -xzC "$tmpdir" "$dirname/dist"
	cp -r -t "$destination" "$tmpdir/$dirname/dist"/*

	rm -rf "$tmpdir"
}


# Download the latest release of Wordpress.
#
# Usage: install::wordpress client/wordpress
#
# TODO Generate the wp-config.php file
# TODO Generate the wp-settings.php file
function install.wordpress() {
	local old_pwd="$( pwd )"

	local destination="${1:-.}"
	local tmpdir=$( mktemp -d )

	local wp="wp --path=${destination}"

	mkdir -p "${destination}"

	curl -# "http://wordpress.org/latest.tar.gz" \
		| tar -xz --directory="${tmpdir}"

	mv "${tmpdir}"/wordpress/* "${destination}"
	rmdir "${tmpdir}/wordpress" && rm -rf "${tmpdir}"

	local db_name db_user db_pass db_host db_prefix
	read -ep 'Database name: ' -i 'wp_' db_name
	read -ep 'Database user: ' -i "${db_name}" db_user
	read -ep 'Database password: ' -i 'password' db_pass
	read -ep 'Database host: ' -i 'localhost' db_host

	read -ep 'Table prefix: ' -i 'wp_' db_prefix

	$wp core config \
		--dbname="${db_name}" \
		--dbuser="${db_user}" \
		--dbpass="${db_pass}" \
		--dbhost="${db_host}" \
		--dbprefix="${db_prefix}"

	local url title admin_user admin_email admin_password
	read -ep 'Site URL: ' -i 'http://' url
	read -ep 'Site title: ' -i "" title

	read -ep 'Admin user: ' -i 'ionata_admin' admin_user
	read -ep 'Admin email: ' -i 'webmaster@ionata.com.au' admin_email
	read -ep 'Admin password: ' -i 'password' admin_password

	$wp core install \
		--url="${url}" \
		--title="${title}" \
		--admin_user="${admin_user}" \
		--admin_email="${admin_email}" \
		--admin_password="${admin_password}"

	local git_url
	echo 'Enter a wp-content git url to clone an existing project, or leave it blank to start a new one'
	read -ep 'Git URL: ' -i '' git_url
	wp_content="${destination}"/wp-content

	if [ -n "${git_url}" ] ; then
		rm -rf "$wp_content"
		git clone -- "${git_url}" "${wp_content}"
	else
		git init "${wp_content}"
	fi
}
