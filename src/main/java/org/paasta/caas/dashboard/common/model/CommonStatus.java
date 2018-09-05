package org.paasta.caas.dashboard.common.model;

import com.google.gson.annotations.SerializedName;
import lombok.Data;

import java.util.List;

/**
 * Common Status Model 클래스
 *
 * @author REX
 * @version 1.0
 * @since 2018.08.09
 */
@Data
public class CommonStatus {

    @SerializedName("availableReplicas")
    private int availableReplicas;

    @SerializedName("fullyLabeledReplicas")
    private int fullyLabeledReplicas;

    @SerializedName("observedGeneration")
    private long observedGeneration;

    @SerializedName("readyReplicas")
    private int readyReplicas;

    @SerializedName("replicas")
    private int replicas;

    // FOR POD :: BEGIN
    private String phase;
    private List containerStatuses;
    // FOR POD :: END

    // FOR NODE :: BEGIN
    private List<CommonCondition> conditions;
    // FOR NODE :: BEGIN

    @SerializedName("podIP")
    private String podIP;

    @SerializedName("qosClass")
    private String qosClass;

    //@SerializedName("conditions")
    //private List<ReplicaSetCondition> conditions;

}
