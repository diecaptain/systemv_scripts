virtual function void display(string prefix = "");
virtual function string psdisplay(string prefix = "");
virtual function vmm_notify copy(vmm_notify to = null);
virtual function int configure(int notification_id = -1,
      		  sync_e sync = ONE_SHOT);
virtual function int is_configured(int notification_id);
virtual function bit is_on(int notification_id);
virtual task wait_for(int notification_id);
virtual task wait_for_off(int notification_id);
virtual function bit is_waited_for(int notification_id);
virtual function void terminated(int notification_id);
virtual function vmm_data status(int notification_id);
virtual function time timestamp(int notification_id);
virtual function void indicate(int notification_id,
          		  vmm_data status = null);
virtual function void set_notification(int notification_id,
      		          vmm_notification ntfy = null);
virtual function vmm_notification get_notification(int notification_id);
virtual function void reset(int     notification_id = -1,
                               reset_e rst_typ         = SOFT);
