---
to: <%= rootDirectory %>/components/modal/AppDialog.tsx
force: true
---
'use client';

import { Dialog, DialogTitle, DialogContent, DialogActions, Button } from '@mui/material';
import { atom, useAtom } from 'jotai';

export type DialogState = {
  open: boolean;
  title: string;
  message: string;
  okLabel?: string;
  cancelLabel?: string;
  onOk?: () => void;
  onCancel?: () => void;
};

export const DialogAtom = atom<DialogState>({
  open: false,
  title: '',
  message: '',
});

export function AppDialog() {
  const [dialog, setDialog] = useAtom(DialogAtom);

  const handleClose = () => {
    setDialog({ ...dialog, open: false });
  };

  const handleOk = () => {
    if (dialog.onOk) dialog.onOk();
    handleClose();
  };

  const handleCancel = () => {
    if (dialog.onCancel) dialog.onCancel();
    handleClose();
  };

  return (
    <Dialog
      open={dialog.open}
      onClose={handleClose}
      aria-labelledby="alert-dialog-title"
      aria-describedby="alert-dialog-description"
    >
      <DialogTitle id="alert-dialog-title">{dialog.title}</DialogTitle>
      <DialogContent>
        <div dangerouslySetInnerHTML={{ __html: dialog.message }} />
      </DialogContent>
      <DialogActions>
        {dialog.cancelLabel && (
          <Button onClick={handleCancel} color="primary">
            {dialog.cancelLabel}
          </Button>
        )}
        <Button onClick={handleOk} color="primary" autoFocus>
          {dialog.okLabel || 'OK'}
        </Button>
      </DialogActions>
    </Dialog>
  );
}
