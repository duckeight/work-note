


public class CollectedDataCount extends DomainEntity {
    private String gatewayId;
    private long timestamp;
    private long count;
}





public class GatewayServerMonitoringQuery {
    private OnlineStatus gatewayServerStatus;
    private OnlineStatus mqttStatus;
    private DeviceUnitStatus deviceStatus;
    private WireStatus wireStatus;
    private String keyword;
}

public class GatewayServerMonitoringRdo {
    private String gatewayServerId;
    private String name;
    private String location;
    private String ip;
    private int port;
    private OnlineStatus Status;
    private OnlineStatus mqttStatus;
}




// 기존
public enum OnlineStatus {
    Online,
    Offline;

}

public enum DeviceUnitStatus {
    Error,
    Normal,
    Unknown,
    Disabled;
}

public enum WireStatus {
    Worning,
    Caution,
    Attention,
    None,
    Disabled; // ?

}

