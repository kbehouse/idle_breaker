export default function useViewTransition() {
  return (callback: () => void) => {
    if (!(document as any).startViewTransition) {
        callback();
        return;
      }
      (document as any).startViewTransition(callback);
    };
  }