
import CommonConstants from '../common/constant/CommonConstant';

export class DataModel {
  private tasks: Array<string> = CommonConstants.TODO_DATA;
  getData(): Array<string> {
    return this.tasks;
  }
}

export default new DataModel();

