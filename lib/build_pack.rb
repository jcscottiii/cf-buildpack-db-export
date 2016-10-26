require 'fileutils'

module BuildPack
  def self.run(build_dir, cache_dir)
    bin_path = "#{build_dir}/bin"
    tmp_path = "#{build_dir}/tmp"

    @mysql_pkg = "#{cache_dir}/mysql.deb"
    mysql_path = "#{tmp_path}/mysql"
    mysql_binaries = "#{mysql_path}/usr/bin"

    FileUtils.mkdir_p bin_path
    FileUtils.mkdir_p tmp_path

    if File.exist?(@mysql_pkg)
      puts "-----> Using MySQL Client package from cache"
    else
      mysql_url = "http://security.debian.org/pool/updates/main/m/mysql-5.5/mysql-client-5.5_5.5.52-0+deb8u1_amd64.deb"

      command = "curl #{mysql_url} -L -s -o #{@mysql_pkg}"

      puts "-----> Downloading MySQL Client package from:"
      puts "  #{mysql_url}"
      puts "-----> using command:"
      puts "  #{command}"
      `#{command}`
    end

    puts "-----> Installing MySQL Client"
    output = `dpkg -x #{@mysql_pkg} #{mysql_path}`
    puts output

    FileUtils.chmod(0755, mysql_binaries)
    FileUtils.mv(mysql_binaries, bin_path)

    puts "-----> cleaning up"
  end

  def cached?
    File.exist?(@mysql_pkg)
  end
end
