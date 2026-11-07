import { makeObservable, observable, action } from "mobx";

export class LoadingOverlayStore {
  isLoading = false;

  constructor() {
    makeObservable(this, {
      isLoading: observable,
      setIsLoading: action,
      withLoading: action,
    });
  }

  setIsLoading = (loading: boolean) => {
    this.isLoading = loading;
  };

  withLoading = async <T>(fn: () => Promise<T>): Promise<T> => {
    this.setIsLoading(true);
    try {
      return await fn();
    } finally {
      this.setIsLoading(false);
    }
  };
}
