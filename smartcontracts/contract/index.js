/*
# Copyright IBM Corp. All Rights Reserved.
#
# SPDX-License-Identifier: Apache-2.0
*/

const shim = require("fabric-shim");
const util = require("util");
const uuidv4 = require("uuid/v4");

var ABstore = class {
  // Initialize the chaincode
  async Init(stub) {
    console.info("========= ABstore Init =========");
    let ret = stub.getFunctionAndParameters();
    console.info(ret);
    let args = ret.params;
    // initialise only if 4 parameters passed.
    if (args.length != 4) {
      return shim.error("Incorrect number of arguments. Expecting 4");
    }

    let A = args[0];
    let B = args[2];
    let Aval = args[1];
    let Bval = args[3];

    if (
      typeof parseInt(Aval) !== "number" ||
      typeof parseInt(Bval) !== "number"
    ) {
      return shim.error("Expecting integer value for asset holding");
    }

    try {
      await stub.putState(A, Buffer.from(Aval));
      try {
        await stub.putState(B, Buffer.from(Bval));
        return shim.success();
      } catch (err) {
        return shim.error(err);
      }
    } catch (err) {
      return shim.error(err);
    }
  }

  async Invoke(stub) {
    let ret = stub.getFunctionAndParameters();
    console.info(ret);
    let method = this[ret.fcn];
    if (!method) {
      console.log("no method of name:" + ret.fcn + " found");
      return shim.success();
    }
    try {
      let payload = await method(stub, ret.params);
      return shim.success(payload);
    } catch (err) {
      console.log(err);
      return shim.error(err);
    }
  }

  async invoke(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }

    // await stub.putState("Hi", JSON.stringify({a:"Hi there"}));
    // let tes = await stub.getState("Hi");
    // console.log(tes.toString());

    let A = args[0];
    let B = args[1];
    if (!A || !B) {
      throw new Error("2 arguments needed");
    }

    await stub.putState(A, B);
  }

  async userCreate(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }

    let tradeEvent = {
      str: "test"
    };
    stub.setEvent("Movement", Buffer.from(JSON.stringify(tradeEvent)));
    console.log(JSON.stringify(tradeEvent));

    let A = args[0];
    let B = args[1];
    if (!A || !B) {
      throw new Error("2 arguments needed");
    }

    await stub.putState(A, B);
  }

  async companyCreate(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }

    let A = args[0];
    let B = args[1];
    if (!A || !B) {
      throw new Error("2 arguments needed");
    }

    await stub.putState(A, B);
  }

  async missionCreate(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }
    let A = args[0];
    let B = args[1];
    let json = JSON.parse(B);
    console.log("incoming parsed json", json);
    if (json.type == "cross") {
      let {
        companyId,
        guestCompanyId,
        missionName,
        tokensLimit,
        type,
        date,
      } = json;
      let { rewardId, description, key1, key2 } = json.reward;

      // Update local company missions array
      let companyBuffer = await stub.getState(companyId);
      let company = JSON.parse(companyBuffer.toString());
      console.log("company::>", company);
      company["missions"].push(A);
      console.log("updated company", company);
      console.log("company id to put", companyId);
      // Put company with missons updated
      await stub.putState(companyId, JSON.stringify(company));

      // Update guest company guest-missions array
      let guestCompanyBuffer = await stub.getState(guestCompanyId);
      let guestCompany = JSON.parse(guestCompanyBuffer.toString());
      console.log("guest company::>", guestCompany);
      guestCompany["guestMissions"].push(A);
      console.log("updated company", guestCompany);
      // Put company with missons updated
      await stub.putState(guestCompanyId, JSON.stringify(guestCompany));
      // Create reward
      await stub.putState(rewardId, JSON.stringify(json.reward));
    } else if (json.type == "self") {
      let { companyId, missionName, tokensLimit, type, date } = json;
      // Update local company missions array
      let companyBuffer = await stub.getState(companyId);
      let company = JSON.parse(companyBuffer.toString());
      console.log("company::>", company);
      company["missions"].push(A);
      console.log("updated company", company);
      console.log("company id to put", companyId);
      // Put company with missons updated
      await stub.putState(companyId, JSON.stringify(company));
    } else {
      throw new Error("Misson type not expected");
    }

    if (!A || !B) {
      throw new Error("2 arguments needed");
    }
    console.log("A::>", A);
    console.log("B::>", B);
    // Put mission record
    await stub.putState(A, B);
  }

  async multipleCrossMissionCreate(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }
    let A = args[0];
    let B = args[1];
    let json = JSON.parse(B);
    console.log("incoming parsed json", json);
    if (json.type == "multipleCross") {
      let {
        companyId,
        guestCompanies,
        guestsNumber,
        tokensLimit,
        type,
        date,
      } = json;

      // Update local company missions array
      let companyBuffer = await stub.getState(companyId);
      let company = JSON.parse(companyBuffer.toString());
      console.log("company::>", company);
      company["missions"].push(A);
      console.log("updated company", company);
      console.log("company id to put", companyId);

      // Put companies with missons updated
      await stub.putState(companyId, JSON.stringify(company));

      // Update guest company guest-missions array
      for (let i = 0; i < guestCompanies.length; i++) {
        let guestCompanyId = guestCompanies[i].companyId;
        let guestCompanyBuffer = await stub.getState(guestCompanyId);
        let guestCompany = JSON.parse(guestCompanyBuffer.toString());
        console.log("guest company::>", guestCompany);
        guestCompany["guestMissions"].push(A);
        console.log("updated company", guestCompany);
        // Put company with missons updated
        await stub.putState(guestCompanyId, JSON.stringify(guestCompany));
        // Create reward
        await stub.putState(uuidv4(), JSON.stringify(guestCompanies[i].reward));
      }
    } else {
      throw new Error("Misson type not expected");
    }

    if (!A || !B) {
      throw new Error("2 arguments needed");
    }
    console.log("A::>", A);
    console.log("B::>", B);
    // Put mission record
    await stub.putState(A, B);
  }

  async getMissions(stub, args) {
    if (args.length != 1) {
      throw new Error("Incorrect number of arguments. Expecting 1");
    }
    let A = args[0];
    if (!A) {
      throw new Error("1 argument needed");
    }
    let json = JSON.parse(A);
    let { companyId } = json;
    let companyBuffer = await stub.getState(companyId);
    let company = JSON.parse(companyBuffer.toString());
    let obj = {};
    let ret = [];
    for (let i = 0; i < company.missions.length; i++) {
      const v = company.missions[i];
      let missionBuffer = await stub.getState(v);
      let mission = JSON.parse(missionBuffer.toString());
      ret.push(mission);
    }
    obj = { result: ret };
    let buf = Buffer.from(JSON.stringify(obj));
    return buf;
  }

  async rewardCreate(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }

    let A = args[0];
    let B = args[1];
    if (!A || !B) {
      throw new Error("2 arguments needed");
    }

    await stub.putState(A, B);
  }

  async missionEnroll(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }
    let A = args[0];
    let B = args[1];
    if (!A || !B) {
      throw new Error("2 arguments needed");
    }
    // Pushear mission al usuario
    let json = JSON.parse(B);
    let { userId, missionId } = json;
    let userBuffer = await stub.getState(userId);
    let user = JSON.parse(userBuffer.toString());
    let missionBuffer = await stub.getState(missionId);
    let mission = JSON.parse(missionBuffer.toString());
    let missionToPush = { ...mission, missionId, movementsPerformed: 0 };
    console.log("user::>", user);
    user["enrolledMissions"].push(missionToPush);
    console.log("updated user", user);
    console.log("user id to put", userId);
    // Put company with missons updated
    await stub.putState(userId, JSON.stringify(user));
  }

  async performMovement(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }
    let A = args[0];
    let B = args[1];
    if (!A || !B) {
      throw new Error("2 arguments needed");
    }
    // Pushear mission al usuario
    let json = JSON.parse(B);
    let { userId, missionId } = json;
    let userBuffer = await stub.getState(userId);
    let user = JSON.parse(userBuffer.toString());
    console.log("user::>", user);
    let missionIndex = user["enrolledMissions"].findIndex((value) => {
      return value.missionId == missionId;
    });
    console.log("missionIndex::>", missionIndex);
    user["enrolledMissions"][missionIndex].movementsPerformed++;
    console.log("updated user", user);
    console.log("user id to put", userId);
    // Put company with missons updated

    // Falta crear registro de movement
    await stub.putState(userId, JSON.stringify(user));

    // Event
    // let tradeEvent = {
    //   userId,
    //   missionId,
    //   userName: user['name'],
    //   movementsPerformed: user['enrolledMissions'][missionIndex]['movementsPerformed']
    // };
    // stub.setEvent("Movement", Buffer.from(JSON.stringify(tradeEvent)));
    // console.log(JSON.stringify(tradeEvent));
  }

  async tokensSend(stub, args) {
    if (args.length != 2) {
      throw new Error("Incorrect number of arguments. Expecting 2");
    }
    let A = args[0];
    let B = args[1];
    if (!A || !B) {
      throw new Error("2 arguments needed");
    }
    let json = JSON.parse(B);
    let { userIdFrom, userIdTo, tokens, transactionId } = json;
    // Push sent transaction id to from user
    let userBufferFrom = await stub.getState(userIdFrom);
    let userFrom = JSON.parse(userBufferFrom.toString());
    console.log("user::>", userFrom);
    if (userFrom.tokens < tokens) {
      throw "No tiene suficientes tokens";
    }
    userFrom.sendTransactions.push(transactionId);
    userFrom.tokens -= tokens;
    await stub.putState(userIdFrom, JSON.stringify(userFrom));

    // Push received transaction id to from user
    let userBufferTo = await stub.getState(userIdTo);
    let userTo = JSON.parse(userBufferTo.toString());
    console.log("user::>", userTo);
    userTo.receivedTransactions.push(transactionId);
    userTo.tokens += tokens;
    await stub.putState(userIdTo, JSON.stringify(userTo));

    // Save transaction
    await stub.putState(A, B);
  }

  // Deletes an entity from state
  async delete(stub, args) {
    if (args.length != 1) {
      throw new Error("Incorrect number of arguments. Expecting 1");
    }

    let A = args[0];

    // Delete the key from the state in ledger
    await stub.deleteState(A);
  }

  // query callback representing the query of a chaincode
  async query(stub, args) {
    if (args.length != 1) {
      throw new Error(
        "Incorrect number of arguments. Expecting name of the person to query"
      );
    }

    let jsonResp = {};
    let A = args[0];

    // Get the state from the ledger
    let Avalbytes = await stub.getState(A);
    if (!Avalbytes || Avalbytes == "") {
      // jsonResp.error = "Failed to get state for " + A;
      throw "Failed to get state";
    }

    jsonResp.name = A;
    jsonResp.amount = Avalbytes.toString();
    console.info("Query Response:");
    console.info(jsonResp);
    return Avalbytes;
  }
};

console.log(">>>>>>>>start");

shim.start(new ABstore());
