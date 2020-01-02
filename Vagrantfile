Vagrant.configure("2") do |config|
  config.vm.define :test_vm do |test_vm|
    test_vm.vm.box = "consul"
    test_vm.vm.provider "libvirt"
    test_vm.vm.synced_folder ".", "/vagrant", disabled: true
  end
end
