require 'spec_helper_acceptance'

describe 'onevm type' do
  before :all do
    pp = <<-EOS
    class { 'one':
      oned => true,
    }
    onetemplate { 'test-vm':
      # Capacity
      cpu    => 1,
      memory => 128,

      # OS
      os_kernel     => '/vmlinuz',
      os_initrd     => '/initrd.img',
      os_root       => 'sda1',
      os_kernel_cmd => 'ro xencons=tty console=tty1',

      # Features
      acpi        => true,
      pae         => true,

      # Disks
      disks  => [ 'Data', 'Experiments', ],

      # Network
      nics   => [ 'Blue', 'Red', ],

      # I/O Devices
      graphics_type   => 'vnc',
      graphics_listen => '0.0.0.0',
      graphics_port   => 5,
    }
    EOS
    apply_manifest(pp, :catch_failures => true)
    apply_manifest(pp, :catch_changes => true)
  end

  describe 'when creating vm' do
    it 'should idempotently run' do
      pending 'Need fix'
      pp = <<-EOS
        onevm { 'new_vm':
          template => 'test-vm',
        }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

  describe 'when destroying a vm' do
    it 'should idempotently run' do
      pp =<<-EOS
      onevm { 'new_vm':
        ensure => absent,
      }
      EOS

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end
  end

end
