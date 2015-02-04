define jmeter::plugin (
  $version
){
  exec { "download-jmeter-plugins-${name}":
    command => "wget -P /root http://jmeter-plugins.org/files/JMeterPlugins-${name}-${version}.zip",
    creates => "/root/JMeterPlugins-${name}-${version}.zip"
  }

  exec { "install-jmeter-plugins-${name}":
    command => "unzip -q -d JMeterPlugins-${name} JMeterPlugins-${name}-${version}.zip && mv JMeterPlugins-${name}/lib/ext/JMeterPlugins-${name}.jar /usr/share/jmeter/lib/ext",
    cwd     => '/root',
    creates => "/usr/share/jmeter/lib/ext/JMeterPlugins-${name}.jar",
    require => [Package['unzip'], Exec['install-jmeter'], Exec["download-jmeter-plugins-${name}"]],
  }
}
