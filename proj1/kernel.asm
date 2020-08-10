
kernel:     file format elf32-i386


Disassembly of section .text:

80100000 <multiboot_header>:
80100000:	02 b0 ad 1b 00 00    	add    0x1bad(%eax),%dh
80100006:	00 00                	add    %al,(%eax)
80100008:	fe 4f 52             	decb   0x52(%edi)
8010000b:	e4                   	.byte 0xe4

8010000c <entry>:

# Entering xv6 on boot processor, with paging off.
.globl entry
entry:
  # Turn on page size extension for 4Mbyte pages
  movl    %cr4, %eax
8010000c:	0f 20 e0             	mov    %cr4,%eax
  orl     $(CR4_PSE), %eax
8010000f:	83 c8 10             	or     $0x10,%eax
  movl    %eax, %cr4
80100012:	0f 22 e0             	mov    %eax,%cr4
  # Set page directory
  movl    $(V2P_WO(entrypgdir)), %eax
80100015:	b8 00 90 10 00       	mov    $0x109000,%eax
  movl    %eax, %cr3
8010001a:	0f 22 d8             	mov    %eax,%cr3
  # Turn on paging.
  movl    %cr0, %eax
8010001d:	0f 20 c0             	mov    %cr0,%eax
  orl     $(CR0_PG|CR0_WP), %eax
80100020:	0d 00 00 01 80       	or     $0x80010000,%eax
  movl    %eax, %cr0
80100025:	0f 22 c0             	mov    %eax,%cr0

  # Set up the stack pointer.
  movl $(stack + KSTACKSIZE), %esp
80100028:	bc 20 b6 10 80       	mov    $0x8010b620,%esp

  # Jump to main(), and switch to executing at
  # high addresses. The indirect call is needed because
  # the assembler produces a PC-relative instruction
  # for a direct jump.
  mov $main, %eax
8010002d:	b8 60 2e 10 80       	mov    $0x80102e60,%eax
  jmp *%eax
80100032:	ff e0                	jmp    *%eax
80100034:	66 90                	xchg   %ax,%ax
80100036:	66 90                	xchg   %ax,%ax
80100038:	66 90                	xchg   %ax,%ax
8010003a:	66 90                	xchg   %ax,%ax
8010003c:	66 90                	xchg   %ax,%ax
8010003e:	66 90                	xchg   %ax,%ax

80100040 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
80100040:	55                   	push   %ebp
80100041:	89 e5                	mov    %esp,%ebp
80100043:	53                   	push   %ebx

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
80100044:	bb 54 b6 10 80       	mov    $0x8010b654,%ebx
  struct buf head;
} bcache;

void
binit(void)
{
80100049:	83 ec 0c             	sub    $0xc,%esp
  struct buf *b;

  initlock(&bcache.lock, "bcache");
8010004c:	68 60 70 10 80       	push   $0x80107060
80100051:	68 20 b6 10 80       	push   $0x8010b620
80100056:	e8 95 41 00 00       	call   801041f0 <initlock>

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
8010005b:	c7 05 6c fd 10 80 1c 	movl   $0x8010fd1c,0x8010fd6c
80100062:	fd 10 80 
  bcache.head.next = &bcache.head;
80100065:	c7 05 70 fd 10 80 1c 	movl   $0x8010fd1c,0x8010fd70
8010006c:	fd 10 80 
8010006f:	83 c4 10             	add    $0x10,%esp
80100072:	ba 1c fd 10 80       	mov    $0x8010fd1c,%edx
80100077:	eb 09                	jmp    80100082 <binit+0x42>
80100079:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80100080:	89 c3                	mov    %eax,%ebx
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
80100082:	8d 43 0c             	lea    0xc(%ebx),%eax
80100085:	83 ec 08             	sub    $0x8,%esp
//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    b->next = bcache.head.next;
80100088:	89 53 54             	mov    %edx,0x54(%ebx)
    b->prev = &bcache.head;
8010008b:	c7 43 50 1c fd 10 80 	movl   $0x8010fd1c,0x50(%ebx)
    initsleeplock(&b->lock, "buffer");
80100092:	68 67 70 10 80       	push   $0x80107067
80100097:	50                   	push   %eax
80100098:	e8 23 40 00 00       	call   801040c0 <initsleeplock>
    bcache.head.next->prev = b;
8010009d:	a1 70 fd 10 80       	mov    0x8010fd70,%eax

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000a2:	83 c4 10             	add    $0x10,%esp
801000a5:	89 da                	mov    %ebx,%edx
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
801000a7:	89 58 50             	mov    %ebx,0x50(%eax)

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000aa:	8d 83 5c 02 00 00    	lea    0x25c(%ebx),%eax
    b->next = bcache.head.next;
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
801000b0:	89 1d 70 fd 10 80    	mov    %ebx,0x8010fd70

//PAGEBREAK!
  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
  bcache.head.next = &bcache.head;
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
801000b6:	3d 1c fd 10 80       	cmp    $0x8010fd1c,%eax
801000bb:	75 c3                	jne    80100080 <binit+0x40>
    b->prev = &bcache.head;
    initsleeplock(&b->lock, "buffer");
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
}
801000bd:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801000c0:	c9                   	leave  
801000c1:	c3                   	ret    
801000c2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801000c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801000d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
801000d0:	55                   	push   %ebp
801000d1:	89 e5                	mov    %esp,%ebp
801000d3:	57                   	push   %edi
801000d4:	56                   	push   %esi
801000d5:	53                   	push   %ebx
801000d6:	83 ec 18             	sub    $0x18,%esp
801000d9:	8b 75 08             	mov    0x8(%ebp),%esi
801000dc:	8b 7d 0c             	mov    0xc(%ebp),%edi
static struct buf*
bget(uint dev, uint blockno)
{
  struct buf *b;

  acquire(&bcache.lock);
801000df:	68 20 b6 10 80       	push   $0x8010b620
801000e4:	e8 67 42 00 00       	call   80104350 <acquire>

  // Is the block already cached?
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
801000e9:	8b 1d 70 fd 10 80    	mov    0x8010fd70,%ebx
801000ef:	83 c4 10             	add    $0x10,%esp
801000f2:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
801000f8:	75 11                	jne    8010010b <bread+0x3b>
801000fa:	eb 24                	jmp    80100120 <bread+0x50>
801000fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100100:	8b 5b 54             	mov    0x54(%ebx),%ebx
80100103:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
80100109:	74 15                	je     80100120 <bread+0x50>
    if(b->dev == dev && b->blockno == blockno){
8010010b:	3b 73 04             	cmp    0x4(%ebx),%esi
8010010e:	75 f0                	jne    80100100 <bread+0x30>
80100110:	3b 7b 08             	cmp    0x8(%ebx),%edi
80100113:	75 eb                	jne    80100100 <bread+0x30>
      b->refcnt++;
80100115:	83 43 4c 01          	addl   $0x1,0x4c(%ebx)
80100119:	eb 3f                	jmp    8010015a <bread+0x8a>
8010011b:	90                   	nop
8010011c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  }

  // Not cached; recycle an unused buffer.
  // Even if refcnt==0, B_DIRTY indicates a buffer is in use
  // because log.c has modified it but not yet committed it.
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
80100120:	8b 1d 6c fd 10 80    	mov    0x8010fd6c,%ebx
80100126:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
8010012c:	75 0d                	jne    8010013b <bread+0x6b>
8010012e:	eb 60                	jmp    80100190 <bread+0xc0>
80100130:	8b 5b 50             	mov    0x50(%ebx),%ebx
80100133:	81 fb 1c fd 10 80    	cmp    $0x8010fd1c,%ebx
80100139:	74 55                	je     80100190 <bread+0xc0>
    if(b->refcnt == 0 && (b->flags & B_DIRTY) == 0) {
8010013b:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010013e:	85 c0                	test   %eax,%eax
80100140:	75 ee                	jne    80100130 <bread+0x60>
80100142:	f6 03 04             	testb  $0x4,(%ebx)
80100145:	75 e9                	jne    80100130 <bread+0x60>
      b->dev = dev;
80100147:	89 73 04             	mov    %esi,0x4(%ebx)
      b->blockno = blockno;
8010014a:	89 7b 08             	mov    %edi,0x8(%ebx)
      b->flags = 0;
8010014d:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
      b->refcnt = 1;
80100153:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
      release(&bcache.lock);
8010015a:	83 ec 0c             	sub    $0xc,%esp
8010015d:	68 20 b6 10 80       	push   $0x8010b620
80100162:	e8 99 42 00 00       	call   80104400 <release>
      acquiresleep(&b->lock);
80100167:	8d 43 0c             	lea    0xc(%ebx),%eax
8010016a:	89 04 24             	mov    %eax,(%esp)
8010016d:	e8 8e 3f 00 00       	call   80104100 <acquiresleep>
80100172:	83 c4 10             	add    $0x10,%esp
bread(uint dev, uint blockno)
{
  struct buf *b;

  b = bget(dev, blockno);
  if((b->flags & B_VALID) == 0) {
80100175:	f6 03 02             	testb  $0x2,(%ebx)
80100178:	75 0c                	jne    80100186 <bread+0xb6>
    iderw(b);
8010017a:	83 ec 0c             	sub    $0xc,%esp
8010017d:	53                   	push   %ebx
8010017e:	e8 6d 1f 00 00       	call   801020f0 <iderw>
80100183:	83 c4 10             	add    $0x10,%esp
  }
  return b;
}
80100186:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100189:	89 d8                	mov    %ebx,%eax
8010018b:	5b                   	pop    %ebx
8010018c:	5e                   	pop    %esi
8010018d:	5f                   	pop    %edi
8010018e:	5d                   	pop    %ebp
8010018f:	c3                   	ret    
      release(&bcache.lock);
      acquiresleep(&b->lock);
      return b;
    }
  }
  panic("bget: no buffers");
80100190:	83 ec 0c             	sub    $0xc,%esp
80100193:	68 6e 70 10 80       	push   $0x8010706e
80100198:	e8 d3 01 00 00       	call   80100370 <panic>
8010019d:	8d 76 00             	lea    0x0(%esi),%esi

801001a0 <bwrite>:
}

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
801001a0:	55                   	push   %ebp
801001a1:	89 e5                	mov    %esp,%ebp
801001a3:	53                   	push   %ebx
801001a4:	83 ec 10             	sub    $0x10,%esp
801001a7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001aa:	8d 43 0c             	lea    0xc(%ebx),%eax
801001ad:	50                   	push   %eax
801001ae:	e8 ed 3f 00 00       	call   801041a0 <holdingsleep>
801001b3:	83 c4 10             	add    $0x10,%esp
801001b6:	85 c0                	test   %eax,%eax
801001b8:	74 0f                	je     801001c9 <bwrite+0x29>
    panic("bwrite");
  b->flags |= B_DIRTY;
801001ba:	83 0b 04             	orl    $0x4,(%ebx)
  iderw(b);
801001bd:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
801001c0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801001c3:	c9                   	leave  
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
  b->flags |= B_DIRTY;
  iderw(b);
801001c4:	e9 27 1f 00 00       	jmp    801020f0 <iderw>
// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("bwrite");
801001c9:	83 ec 0c             	sub    $0xc,%esp
801001cc:	68 7f 70 10 80       	push   $0x8010707f
801001d1:	e8 9a 01 00 00       	call   80100370 <panic>
801001d6:	8d 76 00             	lea    0x0(%esi),%esi
801001d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801001e0 <brelse>:

// Release a locked buffer.
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
801001e0:	55                   	push   %ebp
801001e1:	89 e5                	mov    %esp,%ebp
801001e3:	56                   	push   %esi
801001e4:	53                   	push   %ebx
801001e5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holdingsleep(&b->lock))
801001e8:	83 ec 0c             	sub    $0xc,%esp
801001eb:	8d 73 0c             	lea    0xc(%ebx),%esi
801001ee:	56                   	push   %esi
801001ef:	e8 ac 3f 00 00       	call   801041a0 <holdingsleep>
801001f4:	83 c4 10             	add    $0x10,%esp
801001f7:	85 c0                	test   %eax,%eax
801001f9:	74 66                	je     80100261 <brelse+0x81>
    panic("brelse");

  releasesleep(&b->lock);
801001fb:	83 ec 0c             	sub    $0xc,%esp
801001fe:	56                   	push   %esi
801001ff:	e8 5c 3f 00 00       	call   80104160 <releasesleep>

  acquire(&bcache.lock);
80100204:	c7 04 24 20 b6 10 80 	movl   $0x8010b620,(%esp)
8010020b:	e8 40 41 00 00       	call   80104350 <acquire>
  b->refcnt--;
80100210:	8b 43 4c             	mov    0x4c(%ebx),%eax
  if (b->refcnt == 0) {
80100213:	83 c4 10             	add    $0x10,%esp
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
80100216:	83 e8 01             	sub    $0x1,%eax
  if (b->refcnt == 0) {
80100219:	85 c0                	test   %eax,%eax
    panic("brelse");

  releasesleep(&b->lock);

  acquire(&bcache.lock);
  b->refcnt--;
8010021b:	89 43 4c             	mov    %eax,0x4c(%ebx)
  if (b->refcnt == 0) {
8010021e:	75 2f                	jne    8010024f <brelse+0x6f>
    // no one is waiting for it.
    b->next->prev = b->prev;
80100220:	8b 43 54             	mov    0x54(%ebx),%eax
80100223:	8b 53 50             	mov    0x50(%ebx),%edx
80100226:	89 50 50             	mov    %edx,0x50(%eax)
    b->prev->next = b->next;
80100229:	8b 43 50             	mov    0x50(%ebx),%eax
8010022c:	8b 53 54             	mov    0x54(%ebx),%edx
8010022f:	89 50 54             	mov    %edx,0x54(%eax)
    b->next = bcache.head.next;
80100232:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
    b->prev = &bcache.head;
80100237:	c7 43 50 1c fd 10 80 	movl   $0x8010fd1c,0x50(%ebx)
  b->refcnt--;
  if (b->refcnt == 0) {
    // no one is waiting for it.
    b->next->prev = b->prev;
    b->prev->next = b->next;
    b->next = bcache.head.next;
8010023e:	89 43 54             	mov    %eax,0x54(%ebx)
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
80100241:	a1 70 fd 10 80       	mov    0x8010fd70,%eax
80100246:	89 58 50             	mov    %ebx,0x50(%eax)
    bcache.head.next = b;
80100249:	89 1d 70 fd 10 80    	mov    %ebx,0x8010fd70
  }
  
  release(&bcache.lock);
8010024f:	c7 45 08 20 b6 10 80 	movl   $0x8010b620,0x8(%ebp)
}
80100256:	8d 65 f8             	lea    -0x8(%ebp),%esp
80100259:	5b                   	pop    %ebx
8010025a:	5e                   	pop    %esi
8010025b:	5d                   	pop    %ebp
    b->prev = &bcache.head;
    bcache.head.next->prev = b;
    bcache.head.next = b;
  }
  
  release(&bcache.lock);
8010025c:	e9 9f 41 00 00       	jmp    80104400 <release>
// Move to the head of the MRU list.
void
brelse(struct buf *b)
{
  if(!holdingsleep(&b->lock))
    panic("brelse");
80100261:	83 ec 0c             	sub    $0xc,%esp
80100264:	68 86 70 10 80       	push   $0x80107086
80100269:	e8 02 01 00 00       	call   80100370 <panic>
8010026e:	66 90                	xchg   %ax,%ax

80100270 <consoleread>:
  }
}

int
consoleread(struct inode *ip, char *dst, int n)
{
80100270:	55                   	push   %ebp
80100271:	89 e5                	mov    %esp,%ebp
80100273:	57                   	push   %edi
80100274:	56                   	push   %esi
80100275:	53                   	push   %ebx
80100276:	83 ec 28             	sub    $0x28,%esp
80100279:	8b 7d 08             	mov    0x8(%ebp),%edi
8010027c:	8b 75 0c             	mov    0xc(%ebp),%esi
  uint target;
  int c;

  iunlock(ip);
8010027f:	57                   	push   %edi
80100280:	e8 cb 14 00 00       	call   80101750 <iunlock>
  target = n;
  acquire(&cons.lock);
80100285:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
8010028c:	e8 bf 40 00 00       	call   80104350 <acquire>
  while(n > 0){
80100291:	8b 5d 10             	mov    0x10(%ebp),%ebx
80100294:	83 c4 10             	add    $0x10,%esp
80100297:	31 c0                	xor    %eax,%eax
80100299:	85 db                	test   %ebx,%ebx
8010029b:	0f 8e 9a 00 00 00    	jle    8010033b <consoleread+0xcb>
    while(input.r == input.w){
801002a1:	a1 00 00 11 80       	mov    0x80110000,%eax
801002a6:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
801002ac:	74 24                	je     801002d2 <consoleread+0x62>
801002ae:	eb 58                	jmp    80100308 <consoleread+0x98>
      if(myproc()->killed){
        release(&cons.lock);
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
801002b0:	83 ec 08             	sub    $0x8,%esp
801002b3:	68 80 a5 10 80       	push   $0x8010a580
801002b8:	68 00 00 11 80       	push   $0x80110000
801002bd:	e8 8e 3a 00 00       	call   80103d50 <sleep>

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
    while(input.r == input.w){
801002c2:	a1 00 00 11 80       	mov    0x80110000,%eax
801002c7:	83 c4 10             	add    $0x10,%esp
801002ca:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
801002d0:	75 36                	jne    80100308 <consoleread+0x98>
      if(myproc()->killed){
801002d2:	e8 c9 34 00 00       	call   801037a0 <myproc>
801002d7:	8b 40 2c             	mov    0x2c(%eax),%eax
801002da:	85 c0                	test   %eax,%eax
801002dc:	74 d2                	je     801002b0 <consoleread+0x40>
        release(&cons.lock);
801002de:	83 ec 0c             	sub    $0xc,%esp
801002e1:	68 80 a5 10 80       	push   $0x8010a580
801002e6:	e8 15 41 00 00       	call   80104400 <release>
        ilock(ip);
801002eb:	89 3c 24             	mov    %edi,(%esp)
801002ee:	e8 7d 13 00 00       	call   80101670 <ilock>
        return -1;
801002f3:	83 c4 10             	add    $0x10,%esp
801002f6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  release(&cons.lock);
  ilock(ip);

  return target - n;
}
801002fb:	8d 65 f4             	lea    -0xc(%ebp),%esp
801002fe:	5b                   	pop    %ebx
801002ff:	5e                   	pop    %esi
80100300:	5f                   	pop    %edi
80100301:	5d                   	pop    %ebp
80100302:	c3                   	ret    
80100303:	90                   	nop
80100304:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        ilock(ip);
        return -1;
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
80100308:	8d 50 01             	lea    0x1(%eax),%edx
8010030b:	89 15 00 00 11 80    	mov    %edx,0x80110000
80100311:	89 c2                	mov    %eax,%edx
80100313:	83 e2 7f             	and    $0x7f,%edx
80100316:	0f be 92 80 ff 10 80 	movsbl -0x7fef0080(%edx),%edx
    if(c == C('D')){  // EOF
8010031d:	83 fa 04             	cmp    $0x4,%edx
80100320:	74 39                	je     8010035b <consoleread+0xeb>
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
80100322:	83 c6 01             	add    $0x1,%esi
    --n;
80100325:	83 eb 01             	sub    $0x1,%ebx
    if(c == '\n')
80100328:	83 fa 0a             	cmp    $0xa,%edx
        // caller gets a 0-byte result.
        input.r--;
      }
      break;
    }
    *dst++ = c;
8010032b:	88 56 ff             	mov    %dl,-0x1(%esi)
    --n;
    if(c == '\n')
8010032e:	74 35                	je     80100365 <consoleread+0xf5>
  int c;

  iunlock(ip);
  target = n;
  acquire(&cons.lock);
  while(n > 0){
80100330:	85 db                	test   %ebx,%ebx
80100332:	0f 85 69 ff ff ff    	jne    801002a1 <consoleread+0x31>
80100338:	8b 45 10             	mov    0x10(%ebp),%eax
    *dst++ = c;
    --n;
    if(c == '\n')
      break;
  }
  release(&cons.lock);
8010033b:	83 ec 0c             	sub    $0xc,%esp
8010033e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100341:	68 80 a5 10 80       	push   $0x8010a580
80100346:	e8 b5 40 00 00       	call   80104400 <release>
  ilock(ip);
8010034b:	89 3c 24             	mov    %edi,(%esp)
8010034e:	e8 1d 13 00 00       	call   80101670 <ilock>

  return target - n;
80100353:	83 c4 10             	add    $0x10,%esp
80100356:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80100359:	eb a0                	jmp    801002fb <consoleread+0x8b>
      }
      sleep(&input.r, &cons.lock);
    }
    c = input.buf[input.r++ % INPUT_BUF];
    if(c == C('D')){  // EOF
      if(n < target){
8010035b:	39 5d 10             	cmp    %ebx,0x10(%ebp)
8010035e:	76 05                	jbe    80100365 <consoleread+0xf5>
        // Save ^D for next time, to make sure
        // caller gets a 0-byte result.
        input.r--;
80100360:	a3 00 00 11 80       	mov    %eax,0x80110000
80100365:	8b 45 10             	mov    0x10(%ebp),%eax
80100368:	29 d8                	sub    %ebx,%eax
8010036a:	eb cf                	jmp    8010033b <consoleread+0xcb>
8010036c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100370 <panic>:
    release(&cons.lock);
}

void
panic(char *s)
{
80100370:	55                   	push   %ebp
80100371:	89 e5                	mov    %esp,%ebp
80100373:	56                   	push   %esi
80100374:	53                   	push   %ebx
80100375:	83 ec 30             	sub    $0x30,%esp
}

static inline void
cli(void)
{
  asm volatile("cli");
80100378:	fa                   	cli    
  int i;
  uint pcs[10];

  cli();
  cons.locking = 0;
80100379:	c7 05 b4 a5 10 80 00 	movl   $0x0,0x8010a5b4
80100380:	00 00 00 
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
80100383:	8d 5d d0             	lea    -0x30(%ebp),%ebx
80100386:	8d 75 f8             	lea    -0x8(%ebp),%esi
  uint pcs[10];

  cli();
  cons.locking = 0;
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
80100389:	e8 62 23 00 00       	call   801026f0 <lapicid>
8010038e:	83 ec 08             	sub    $0x8,%esp
80100391:	50                   	push   %eax
80100392:	68 8d 70 10 80       	push   $0x8010708d
80100397:	e8 c4 02 00 00       	call   80100660 <cprintf>
  cprintf(s);
8010039c:	58                   	pop    %eax
8010039d:	ff 75 08             	pushl  0x8(%ebp)
801003a0:	e8 bb 02 00 00       	call   80100660 <cprintf>
  cprintf("\n");
801003a5:	c7 04 24 4b 7a 10 80 	movl   $0x80107a4b,(%esp)
801003ac:	e8 af 02 00 00       	call   80100660 <cprintf>
  getcallerpcs(&s, pcs);
801003b1:	5a                   	pop    %edx
801003b2:	8d 45 08             	lea    0x8(%ebp),%eax
801003b5:	59                   	pop    %ecx
801003b6:	53                   	push   %ebx
801003b7:	50                   	push   %eax
801003b8:	e8 53 3e 00 00       	call   80104210 <getcallerpcs>
801003bd:	83 c4 10             	add    $0x10,%esp
  for(i=0; i<10; i++)
    cprintf(" %p", pcs[i]);
801003c0:	83 ec 08             	sub    $0x8,%esp
801003c3:	ff 33                	pushl  (%ebx)
801003c5:	83 c3 04             	add    $0x4,%ebx
801003c8:	68 a1 70 10 80       	push   $0x801070a1
801003cd:	e8 8e 02 00 00       	call   80100660 <cprintf>
  // use lapiccpunum so that we can call panic from mycpu()
  cprintf("lapicid %d: panic: ", lapicid());
  cprintf(s);
  cprintf("\n");
  getcallerpcs(&s, pcs);
  for(i=0; i<10; i++)
801003d2:	83 c4 10             	add    $0x10,%esp
801003d5:	39 f3                	cmp    %esi,%ebx
801003d7:	75 e7                	jne    801003c0 <panic+0x50>
    cprintf(" %p", pcs[i]);
  panicked = 1; // freeze other CPU
801003d9:	c7 05 b8 a5 10 80 01 	movl   $0x1,0x8010a5b8
801003e0:	00 00 00 
801003e3:	eb fe                	jmp    801003e3 <panic+0x73>
801003e5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801003e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801003f0 <consputc>:
}

void
consputc(int c)
{
  if(panicked){
801003f0:	8b 15 b8 a5 10 80    	mov    0x8010a5b8,%edx
801003f6:	85 d2                	test   %edx,%edx
801003f8:	74 06                	je     80100400 <consputc+0x10>
801003fa:	fa                   	cli    
801003fb:	eb fe                	jmp    801003fb <consputc+0xb>
801003fd:	8d 76 00             	lea    0x0(%esi),%esi
  crt[pos] = ' ' | 0x0700;
}

void
consputc(int c)
{
80100400:	55                   	push   %ebp
80100401:	89 e5                	mov    %esp,%ebp
80100403:	57                   	push   %edi
80100404:	56                   	push   %esi
80100405:	53                   	push   %ebx
80100406:	89 c3                	mov    %eax,%ebx
80100408:	83 ec 0c             	sub    $0xc,%esp
    cli();
    for(;;)
      ;
  }

  if(c == BACKSPACE){
8010040b:	3d 00 01 00 00       	cmp    $0x100,%eax
80100410:	0f 84 b8 00 00 00    	je     801004ce <consputc+0xde>
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
80100416:	83 ec 0c             	sub    $0xc,%esp
80100419:	50                   	push   %eax
8010041a:	e8 01 58 00 00       	call   80105c20 <uartputc>
8010041f:	83 c4 10             	add    $0x10,%esp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100422:	bf d4 03 00 00       	mov    $0x3d4,%edi
80100427:	b8 0e 00 00 00       	mov    $0xe,%eax
8010042c:	89 fa                	mov    %edi,%edx
8010042e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010042f:	be d5 03 00 00       	mov    $0x3d5,%esi
80100434:	89 f2                	mov    %esi,%edx
80100436:	ec                   	in     (%dx),%al
{
  int pos;

  // Cursor position: col + 80*row.
  outb(CRTPORT, 14);
  pos = inb(CRTPORT+1) << 8;
80100437:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
8010043a:	89 fa                	mov    %edi,%edx
8010043c:	c1 e0 08             	shl    $0x8,%eax
8010043f:	89 c1                	mov    %eax,%ecx
80100441:	b8 0f 00 00 00       	mov    $0xf,%eax
80100446:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80100447:	89 f2                	mov    %esi,%edx
80100449:	ec                   	in     (%dx),%al
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);
8010044a:	0f b6 c0             	movzbl %al,%eax
8010044d:	09 c8                	or     %ecx,%eax

  if(c == '\n')
8010044f:	83 fb 0a             	cmp    $0xa,%ebx
80100452:	0f 84 0b 01 00 00    	je     80100563 <consputc+0x173>
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
80100458:	81 fb 00 01 00 00    	cmp    $0x100,%ebx
8010045e:	0f 84 e6 00 00 00    	je     8010054a <consputc+0x15a>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white
80100464:	0f b6 d3             	movzbl %bl,%edx
80100467:	8d 78 01             	lea    0x1(%eax),%edi
8010046a:	80 ce 07             	or     $0x7,%dh
8010046d:	66 89 94 00 00 80 0b 	mov    %dx,-0x7ff48000(%eax,%eax,1)
80100474:	80 

  if(pos < 0 || pos > 25*80)
80100475:	81 ff d0 07 00 00    	cmp    $0x7d0,%edi
8010047b:	0f 8f bc 00 00 00    	jg     8010053d <consputc+0x14d>
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
80100481:	81 ff 7f 07 00 00    	cmp    $0x77f,%edi
80100487:	7f 6f                	jg     801004f8 <consputc+0x108>
80100489:	89 f8                	mov    %edi,%eax
8010048b:	8d 8c 3f 00 80 0b 80 	lea    -0x7ff48000(%edi,%edi,1),%ecx
80100492:	89 fb                	mov    %edi,%ebx
80100494:	c1 e8 08             	shr    $0x8,%eax
80100497:	89 c6                	mov    %eax,%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80100499:	bf d4 03 00 00       	mov    $0x3d4,%edi
8010049e:	b8 0e 00 00 00       	mov    $0xe,%eax
801004a3:	89 fa                	mov    %edi,%edx
801004a5:	ee                   	out    %al,(%dx)
801004a6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004ab:	89 f0                	mov    %esi,%eax
801004ad:	ee                   	out    %al,(%dx)
801004ae:	b8 0f 00 00 00       	mov    $0xf,%eax
801004b3:	89 fa                	mov    %edi,%edx
801004b5:	ee                   	out    %al,(%dx)
801004b6:	ba d5 03 00 00       	mov    $0x3d5,%edx
801004bb:	89 d8                	mov    %ebx,%eax
801004bd:	ee                   	out    %al,(%dx)

  outb(CRTPORT, 14);
  outb(CRTPORT+1, pos>>8);
  outb(CRTPORT, 15);
  outb(CRTPORT+1, pos);
  crt[pos] = ' ' | 0x0700;
801004be:	b8 20 07 00 00       	mov    $0x720,%eax
801004c3:	66 89 01             	mov    %ax,(%ecx)
  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
  } else
    uartputc(c);
  cgaputc(c);
}
801004c6:	8d 65 f4             	lea    -0xc(%ebp),%esp
801004c9:	5b                   	pop    %ebx
801004ca:	5e                   	pop    %esi
801004cb:	5f                   	pop    %edi
801004cc:	5d                   	pop    %ebp
801004cd:	c3                   	ret    
    for(;;)
      ;
  }

  if(c == BACKSPACE){
    uartputc('\b'); uartputc(' '); uartputc('\b');
801004ce:	83 ec 0c             	sub    $0xc,%esp
801004d1:	6a 08                	push   $0x8
801004d3:	e8 48 57 00 00       	call   80105c20 <uartputc>
801004d8:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
801004df:	e8 3c 57 00 00       	call   80105c20 <uartputc>
801004e4:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
801004eb:	e8 30 57 00 00       	call   80105c20 <uartputc>
801004f0:	83 c4 10             	add    $0x10,%esp
801004f3:	e9 2a ff ff ff       	jmp    80100422 <consputc+0x32>

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004f8:	83 ec 04             	sub    $0x4,%esp
    pos -= 80;
801004fb:	8d 5f b0             	lea    -0x50(%edi),%ebx

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
801004fe:	68 60 0e 00 00       	push   $0xe60
80100503:	68 a0 80 0b 80       	push   $0x800b80a0
80100508:	68 00 80 0b 80       	push   $0x800b8000
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
8010050d:	8d b4 1b 00 80 0b 80 	lea    -0x7ff48000(%ebx,%ebx,1),%esi

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");

  if((pos/80) >= 24){  // Scroll up.
    memmove(crt, crt+80, sizeof(crt[0])*23*80);
80100514:	e8 e7 3f 00 00       	call   80104500 <memmove>
    pos -= 80;
    memset(crt+pos, 0, sizeof(crt[0])*(24*80 - pos));
80100519:	b8 80 07 00 00       	mov    $0x780,%eax
8010051e:	83 c4 0c             	add    $0xc,%esp
80100521:	29 d8                	sub    %ebx,%eax
80100523:	01 c0                	add    %eax,%eax
80100525:	50                   	push   %eax
80100526:	6a 00                	push   $0x0
80100528:	56                   	push   %esi
80100529:	e8 22 3f 00 00       	call   80104450 <memset>
8010052e:	89 f1                	mov    %esi,%ecx
80100530:	83 c4 10             	add    $0x10,%esp
80100533:	be 07 00 00 00       	mov    $0x7,%esi
80100538:	e9 5c ff ff ff       	jmp    80100499 <consputc+0xa9>
    if(pos > 0) --pos;
  } else
    crt[pos++] = (c&0xff) | 0x0700;  // black on white

  if(pos < 0 || pos > 25*80)
    panic("pos under/overflow");
8010053d:	83 ec 0c             	sub    $0xc,%esp
80100540:	68 a5 70 10 80       	push   $0x801070a5
80100545:	e8 26 fe ff ff       	call   80100370 <panic>
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
  else if(c == BACKSPACE){
    if(pos > 0) --pos;
8010054a:	85 c0                	test   %eax,%eax
8010054c:	8d 78 ff             	lea    -0x1(%eax),%edi
8010054f:	0f 85 20 ff ff ff    	jne    80100475 <consputc+0x85>
80100555:	b9 00 80 0b 80       	mov    $0x800b8000,%ecx
8010055a:	31 db                	xor    %ebx,%ebx
8010055c:	31 f6                	xor    %esi,%esi
8010055e:	e9 36 ff ff ff       	jmp    80100499 <consputc+0xa9>
  pos = inb(CRTPORT+1) << 8;
  outb(CRTPORT, 15);
  pos |= inb(CRTPORT+1);

  if(c == '\n')
    pos += 80 - pos%80;
80100563:	ba 67 66 66 66       	mov    $0x66666667,%edx
80100568:	f7 ea                	imul   %edx
8010056a:	89 d0                	mov    %edx,%eax
8010056c:	c1 e8 05             	shr    $0x5,%eax
8010056f:	8d 04 80             	lea    (%eax,%eax,4),%eax
80100572:	c1 e0 04             	shl    $0x4,%eax
80100575:	8d 78 50             	lea    0x50(%eax),%edi
80100578:	e9 f8 fe ff ff       	jmp    80100475 <consputc+0x85>
8010057d:	8d 76 00             	lea    0x0(%esi),%esi

80100580 <printint>:
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
80100580:	55                   	push   %ebp
80100581:	89 e5                	mov    %esp,%ebp
80100583:	57                   	push   %edi
80100584:	56                   	push   %esi
80100585:	53                   	push   %ebx
80100586:	89 d6                	mov    %edx,%esi
80100588:	83 ec 2c             	sub    $0x2c,%esp
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
8010058b:	85 c9                	test   %ecx,%ecx
  int locking;
} cons;

static void
printint(int xx, int base, int sign)
{
8010058d:	89 4d d4             	mov    %ecx,-0x2c(%ebp)
  static char digits[] = "0123456789abcdef";
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
80100590:	74 0c                	je     8010059e <printint+0x1e>
80100592:	89 c7                	mov    %eax,%edi
80100594:	c1 ef 1f             	shr    $0x1f,%edi
80100597:	85 c0                	test   %eax,%eax
80100599:	89 7d d4             	mov    %edi,-0x2c(%ebp)
8010059c:	78 51                	js     801005ef <printint+0x6f>
    x = -xx;
  else
    x = xx;

  i = 0;
8010059e:	31 ff                	xor    %edi,%edi
801005a0:	8d 5d d7             	lea    -0x29(%ebp),%ebx
801005a3:	eb 05                	jmp    801005aa <printint+0x2a>
801005a5:	8d 76 00             	lea    0x0(%esi),%esi
  do{
    buf[i++] = digits[x % base];
801005a8:	89 cf                	mov    %ecx,%edi
801005aa:	31 d2                	xor    %edx,%edx
801005ac:	8d 4f 01             	lea    0x1(%edi),%ecx
801005af:	f7 f6                	div    %esi
801005b1:	0f b6 92 d0 70 10 80 	movzbl -0x7fef8f30(%edx),%edx
  }while((x /= base) != 0);
801005b8:	85 c0                	test   %eax,%eax
  else
    x = xx;

  i = 0;
  do{
    buf[i++] = digits[x % base];
801005ba:	88 14 0b             	mov    %dl,(%ebx,%ecx,1)
  }while((x /= base) != 0);
801005bd:	75 e9                	jne    801005a8 <printint+0x28>

  if(sign)
801005bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
801005c2:	85 c0                	test   %eax,%eax
801005c4:	74 08                	je     801005ce <printint+0x4e>
    buf[i++] = '-';
801005c6:	c6 44 0d d8 2d       	movb   $0x2d,-0x28(%ebp,%ecx,1)
801005cb:	8d 4f 02             	lea    0x2(%edi),%ecx
801005ce:	8d 74 0d d7          	lea    -0x29(%ebp,%ecx,1),%esi
801005d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  while(--i >= 0)
    consputc(buf[i]);
801005d8:	0f be 06             	movsbl (%esi),%eax
801005db:	83 ee 01             	sub    $0x1,%esi
801005de:	e8 0d fe ff ff       	call   801003f0 <consputc>
  }while((x /= base) != 0);

  if(sign)
    buf[i++] = '-';

  while(--i >= 0)
801005e3:	39 de                	cmp    %ebx,%esi
801005e5:	75 f1                	jne    801005d8 <printint+0x58>
    consputc(buf[i]);
}
801005e7:	83 c4 2c             	add    $0x2c,%esp
801005ea:	5b                   	pop    %ebx
801005eb:	5e                   	pop    %esi
801005ec:	5f                   	pop    %edi
801005ed:	5d                   	pop    %ebp
801005ee:	c3                   	ret    
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    x = -xx;
801005ef:	f7 d8                	neg    %eax
801005f1:	eb ab                	jmp    8010059e <printint+0x1e>
801005f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801005f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100600 <consolewrite>:
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
80100600:	55                   	push   %ebp
80100601:	89 e5                	mov    %esp,%ebp
80100603:	57                   	push   %edi
80100604:	56                   	push   %esi
80100605:	53                   	push   %ebx
80100606:	83 ec 18             	sub    $0x18,%esp
  int i;

  iunlock(ip);
80100609:	ff 75 08             	pushl  0x8(%ebp)
  return target - n;
}

int
consolewrite(struct inode *ip, char *buf, int n)
{
8010060c:	8b 75 10             	mov    0x10(%ebp),%esi
  int i;

  iunlock(ip);
8010060f:	e8 3c 11 00 00       	call   80101750 <iunlock>
  acquire(&cons.lock);
80100614:	c7 04 24 80 a5 10 80 	movl   $0x8010a580,(%esp)
8010061b:	e8 30 3d 00 00       	call   80104350 <acquire>
80100620:	8b 7d 0c             	mov    0xc(%ebp),%edi
  for(i = 0; i < n; i++)
80100623:	83 c4 10             	add    $0x10,%esp
80100626:	85 f6                	test   %esi,%esi
80100628:	8d 1c 37             	lea    (%edi,%esi,1),%ebx
8010062b:	7e 12                	jle    8010063f <consolewrite+0x3f>
8010062d:	8d 76 00             	lea    0x0(%esi),%esi
    consputc(buf[i] & 0xff);
80100630:	0f b6 07             	movzbl (%edi),%eax
80100633:	83 c7 01             	add    $0x1,%edi
80100636:	e8 b5 fd ff ff       	call   801003f0 <consputc>
{
  int i;

  iunlock(ip);
  acquire(&cons.lock);
  for(i = 0; i < n; i++)
8010063b:	39 df                	cmp    %ebx,%edi
8010063d:	75 f1                	jne    80100630 <consolewrite+0x30>
    consputc(buf[i] & 0xff);
  release(&cons.lock);
8010063f:	83 ec 0c             	sub    $0xc,%esp
80100642:	68 80 a5 10 80       	push   $0x8010a580
80100647:	e8 b4 3d 00 00       	call   80104400 <release>
  ilock(ip);
8010064c:	58                   	pop    %eax
8010064d:	ff 75 08             	pushl  0x8(%ebp)
80100650:	e8 1b 10 00 00       	call   80101670 <ilock>

  return n;
}
80100655:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100658:	89 f0                	mov    %esi,%eax
8010065a:	5b                   	pop    %ebx
8010065b:	5e                   	pop    %esi
8010065c:	5f                   	pop    %edi
8010065d:	5d                   	pop    %ebp
8010065e:	c3                   	ret    
8010065f:	90                   	nop

80100660 <cprintf>:
//PAGEBREAK: 50

// Print to the console. only understands %d, %x, %p, %s.
void
cprintf(char *fmt, ...)
{
80100660:	55                   	push   %ebp
80100661:	89 e5                	mov    %esp,%ebp
80100663:	57                   	push   %edi
80100664:	56                   	push   %esi
80100665:	53                   	push   %ebx
80100666:	83 ec 1c             	sub    $0x1c,%esp
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100669:	a1 b4 a5 10 80       	mov    0x8010a5b4,%eax
  if(locking)
8010066e:	85 c0                	test   %eax,%eax
{
  int i, c, locking;
  uint *argp;
  char *s;

  locking = cons.locking;
80100670:	89 45 e0             	mov    %eax,-0x20(%ebp)
  if(locking)
80100673:	0f 85 47 01 00 00    	jne    801007c0 <cprintf+0x160>
    acquire(&cons.lock);

  if (fmt == 0)
80100679:	8b 45 08             	mov    0x8(%ebp),%eax
8010067c:	85 c0                	test   %eax,%eax
8010067e:	89 c1                	mov    %eax,%ecx
80100680:	0f 84 4f 01 00 00    	je     801007d5 <cprintf+0x175>
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
80100686:	0f b6 00             	movzbl (%eax),%eax
80100689:	31 db                	xor    %ebx,%ebx
8010068b:	8d 75 0c             	lea    0xc(%ebp),%esi
8010068e:	89 cf                	mov    %ecx,%edi
80100690:	85 c0                	test   %eax,%eax
80100692:	75 55                	jne    801006e9 <cprintf+0x89>
80100694:	eb 68                	jmp    801006fe <cprintf+0x9e>
80100696:	8d 76 00             	lea    0x0(%esi),%esi
80100699:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(c != '%'){
      consputc(c);
      continue;
    }
    c = fmt[++i] & 0xff;
801006a0:	83 c3 01             	add    $0x1,%ebx
801006a3:	0f b6 14 1f          	movzbl (%edi,%ebx,1),%edx
    if(c == 0)
801006a7:	85 d2                	test   %edx,%edx
801006a9:	74 53                	je     801006fe <cprintf+0x9e>
      break;
    switch(c){
801006ab:	83 fa 70             	cmp    $0x70,%edx
801006ae:	74 7a                	je     8010072a <cprintf+0xca>
801006b0:	7f 6e                	jg     80100720 <cprintf+0xc0>
801006b2:	83 fa 25             	cmp    $0x25,%edx
801006b5:	0f 84 ad 00 00 00    	je     80100768 <cprintf+0x108>
801006bb:	83 fa 64             	cmp    $0x64,%edx
801006be:	0f 85 84 00 00 00    	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
801006c4:	8d 46 04             	lea    0x4(%esi),%eax
801006c7:	b9 01 00 00 00       	mov    $0x1,%ecx
801006cc:	ba 0a 00 00 00       	mov    $0xa,%edx
801006d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801006d4:	8b 06                	mov    (%esi),%eax
801006d6:	e8 a5 fe ff ff       	call   80100580 <printint>
801006db:	8b 75 e4             	mov    -0x1c(%ebp),%esi

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006de:	83 c3 01             	add    $0x1,%ebx
801006e1:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006e5:	85 c0                	test   %eax,%eax
801006e7:	74 15                	je     801006fe <cprintf+0x9e>
    if(c != '%'){
801006e9:	83 f8 25             	cmp    $0x25,%eax
801006ec:	74 b2                	je     801006a0 <cprintf+0x40>
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
801006ee:	e8 fd fc ff ff       	call   801003f0 <consputc>

  if (fmt == 0)
    panic("null fmt");

  argp = (uint*)(void*)(&fmt + 1);
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
801006f3:	83 c3 01             	add    $0x1,%ebx
801006f6:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
801006fa:	85 c0                	test   %eax,%eax
801006fc:	75 eb                	jne    801006e9 <cprintf+0x89>
      consputc(c);
      break;
    }
  }

  if(locking)
801006fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
80100701:	85 c0                	test   %eax,%eax
80100703:	74 10                	je     80100715 <cprintf+0xb5>
    release(&cons.lock);
80100705:	83 ec 0c             	sub    $0xc,%esp
80100708:	68 80 a5 10 80       	push   $0x8010a580
8010070d:	e8 ee 3c 00 00       	call   80104400 <release>
80100712:	83 c4 10             	add    $0x10,%esp
}
80100715:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100718:	5b                   	pop    %ebx
80100719:	5e                   	pop    %esi
8010071a:	5f                   	pop    %edi
8010071b:	5d                   	pop    %ebp
8010071c:	c3                   	ret    
8010071d:	8d 76 00             	lea    0x0(%esi),%esi
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
80100720:	83 fa 73             	cmp    $0x73,%edx
80100723:	74 5b                	je     80100780 <cprintf+0x120>
80100725:	83 fa 78             	cmp    $0x78,%edx
80100728:	75 1e                	jne    80100748 <cprintf+0xe8>
    case 'd':
      printint(*argp++, 10, 1);
      break;
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
8010072a:	8d 46 04             	lea    0x4(%esi),%eax
8010072d:	31 c9                	xor    %ecx,%ecx
8010072f:	ba 10 00 00 00       	mov    $0x10,%edx
80100734:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80100737:	8b 06                	mov    (%esi),%eax
80100739:	e8 42 fe ff ff       	call   80100580 <printint>
8010073e:	8b 75 e4             	mov    -0x1c(%ebp),%esi
      break;
80100741:	eb 9b                	jmp    801006de <cprintf+0x7e>
80100743:	90                   	nop
80100744:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case '%':
      consputc('%');
      break;
    default:
      // Print unknown % sequence to draw attention.
      consputc('%');
80100748:	b8 25 00 00 00       	mov    $0x25,%eax
8010074d:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80100750:	e8 9b fc ff ff       	call   801003f0 <consputc>
      consputc(c);
80100755:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80100758:	89 d0                	mov    %edx,%eax
8010075a:	e8 91 fc ff ff       	call   801003f0 <consputc>
      break;
8010075f:	e9 7a ff ff ff       	jmp    801006de <cprintf+0x7e>
80100764:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        s = "(null)";
      for(; *s; s++)
        consputc(*s);
      break;
    case '%':
      consputc('%');
80100768:	b8 25 00 00 00       	mov    $0x25,%eax
8010076d:	e8 7e fc ff ff       	call   801003f0 <consputc>
80100772:	e9 7c ff ff ff       	jmp    801006f3 <cprintf+0x93>
80100777:	89 f6                	mov    %esi,%esi
80100779:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
80100780:	8d 46 04             	lea    0x4(%esi),%eax
80100783:	8b 36                	mov    (%esi),%esi
80100785:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        s = "(null)";
80100788:	b8 b8 70 10 80       	mov    $0x801070b8,%eax
8010078d:	85 f6                	test   %esi,%esi
8010078f:	0f 44 f0             	cmove  %eax,%esi
      for(; *s; s++)
80100792:	0f be 06             	movsbl (%esi),%eax
80100795:	84 c0                	test   %al,%al
80100797:	74 16                	je     801007af <cprintf+0x14f>
80100799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007a0:	83 c6 01             	add    $0x1,%esi
        consputc(*s);
801007a3:	e8 48 fc ff ff       	call   801003f0 <consputc>
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
        s = "(null)";
      for(; *s; s++)
801007a8:	0f be 06             	movsbl (%esi),%eax
801007ab:	84 c0                	test   %al,%al
801007ad:	75 f1                	jne    801007a0 <cprintf+0x140>
    case 'x':
    case 'p':
      printint(*argp++, 16, 0);
      break;
    case 's':
      if((s = (char*)*argp++) == 0)
801007af:	8b 75 e4             	mov    -0x1c(%ebp),%esi
801007b2:	e9 27 ff ff ff       	jmp    801006de <cprintf+0x7e>
801007b7:	89 f6                	mov    %esi,%esi
801007b9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  uint *argp;
  char *s;

  locking = cons.locking;
  if(locking)
    acquire(&cons.lock);
801007c0:	83 ec 0c             	sub    $0xc,%esp
801007c3:	68 80 a5 10 80       	push   $0x8010a580
801007c8:	e8 83 3b 00 00       	call   80104350 <acquire>
801007cd:	83 c4 10             	add    $0x10,%esp
801007d0:	e9 a4 fe ff ff       	jmp    80100679 <cprintf+0x19>

  if (fmt == 0)
    panic("null fmt");
801007d5:	83 ec 0c             	sub    $0xc,%esp
801007d8:	68 bf 70 10 80       	push   $0x801070bf
801007dd:	e8 8e fb ff ff       	call   80100370 <panic>
801007e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801007e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801007f0 <consoleintr>:

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f0:	55                   	push   %ebp
801007f1:	89 e5                	mov    %esp,%ebp
801007f3:	57                   	push   %edi
801007f4:	56                   	push   %esi
801007f5:	53                   	push   %ebx
  int c, doprocdump = 0;
801007f6:	31 f6                	xor    %esi,%esi

#define C(x)  ((x)-'@')  // Control-x

void
consoleintr(int (*getc)(void))
{
801007f8:	83 ec 18             	sub    $0x18,%esp
801007fb:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int c, doprocdump = 0;

  acquire(&cons.lock);
801007fe:	68 80 a5 10 80       	push   $0x8010a580
80100803:	e8 48 3b 00 00       	call   80104350 <acquire>
  while((c = getc()) >= 0){
80100808:	83 c4 10             	add    $0x10,%esp
8010080b:	90                   	nop
8010080c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100810:	ff d3                	call   *%ebx
80100812:	85 c0                	test   %eax,%eax
80100814:	89 c7                	mov    %eax,%edi
80100816:	78 48                	js     80100860 <consoleintr+0x70>
    switch(c){
80100818:	83 ff 10             	cmp    $0x10,%edi
8010081b:	0f 84 3f 01 00 00    	je     80100960 <consoleintr+0x170>
80100821:	7e 5d                	jle    80100880 <consoleintr+0x90>
80100823:	83 ff 15             	cmp    $0x15,%edi
80100826:	0f 84 dc 00 00 00    	je     80100908 <consoleintr+0x118>
8010082c:	83 ff 7f             	cmp    $0x7f,%edi
8010082f:	75 54                	jne    80100885 <consoleintr+0x95>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    case C('H'): case '\x7f':  // Backspace
      if(input.e != input.w){
80100831:	a1 08 00 11 80       	mov    0x80110008,%eax
80100836:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
8010083c:	74 d2                	je     80100810 <consoleintr+0x20>
        input.e--;
8010083e:	83 e8 01             	sub    $0x1,%eax
80100841:	a3 08 00 11 80       	mov    %eax,0x80110008
        consputc(BACKSPACE);
80100846:	b8 00 01 00 00       	mov    $0x100,%eax
8010084b:	e8 a0 fb ff ff       	call   801003f0 <consputc>
consoleintr(int (*getc)(void))
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
80100850:	ff d3                	call   *%ebx
80100852:	85 c0                	test   %eax,%eax
80100854:	89 c7                	mov    %eax,%edi
80100856:	79 c0                	jns    80100818 <consoleintr+0x28>
80100858:	90                   	nop
80100859:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        }
      }
      break;
    }
  }
  release(&cons.lock);
80100860:	83 ec 0c             	sub    $0xc,%esp
80100863:	68 80 a5 10 80       	push   $0x8010a580
80100868:	e8 93 3b 00 00       	call   80104400 <release>
  if(doprocdump) {
8010086d:	83 c4 10             	add    $0x10,%esp
80100870:	85 f6                	test   %esi,%esi
80100872:	0f 85 f8 00 00 00    	jne    80100970 <consoleintr+0x180>
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100878:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010087b:	5b                   	pop    %ebx
8010087c:	5e                   	pop    %esi
8010087d:	5f                   	pop    %edi
8010087e:	5d                   	pop    %ebp
8010087f:	c3                   	ret    
{
  int c, doprocdump = 0;

  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
80100880:	83 ff 08             	cmp    $0x8,%edi
80100883:	74 ac                	je     80100831 <consoleintr+0x41>
        input.e--;
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
80100885:	85 ff                	test   %edi,%edi
80100887:	74 87                	je     80100810 <consoleintr+0x20>
80100889:	a1 08 00 11 80       	mov    0x80110008,%eax
8010088e:	89 c2                	mov    %eax,%edx
80100890:	2b 15 00 00 11 80    	sub    0x80110000,%edx
80100896:	83 fa 7f             	cmp    $0x7f,%edx
80100899:	0f 87 71 ff ff ff    	ja     80100810 <consoleintr+0x20>
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010089f:	8d 50 01             	lea    0x1(%eax),%edx
801008a2:	83 e0 7f             	and    $0x7f,%eax
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008a5:	83 ff 0d             	cmp    $0xd,%edi
        input.buf[input.e++ % INPUT_BUF] = c;
801008a8:	89 15 08 00 11 80    	mov    %edx,0x80110008
        consputc(BACKSPACE);
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
801008ae:	0f 84 c8 00 00 00    	je     8010097c <consoleintr+0x18c>
        input.buf[input.e++ % INPUT_BUF] = c;
801008b4:	89 f9                	mov    %edi,%ecx
801008b6:	88 88 80 ff 10 80    	mov    %cl,-0x7fef0080(%eax)
        consputc(c);
801008bc:	89 f8                	mov    %edi,%eax
801008be:	e8 2d fb ff ff       	call   801003f0 <consputc>
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
801008c3:	83 ff 0a             	cmp    $0xa,%edi
801008c6:	0f 84 c1 00 00 00    	je     8010098d <consoleintr+0x19d>
801008cc:	83 ff 04             	cmp    $0x4,%edi
801008cf:	0f 84 b8 00 00 00    	je     8010098d <consoleintr+0x19d>
801008d5:	a1 00 00 11 80       	mov    0x80110000,%eax
801008da:	83 e8 80             	sub    $0xffffff80,%eax
801008dd:	39 05 08 00 11 80    	cmp    %eax,0x80110008
801008e3:	0f 85 27 ff ff ff    	jne    80100810 <consoleintr+0x20>
          input.w = input.e;
          wakeup(&input.r);
801008e9:	83 ec 0c             	sub    $0xc,%esp
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
        consputc(c);
        if(c == '\n' || c == C('D') || input.e == input.r+INPUT_BUF){
          input.w = input.e;
801008ec:	a3 04 00 11 80       	mov    %eax,0x80110004
          wakeup(&input.r);
801008f1:	68 00 00 11 80       	push   $0x80110000
801008f6:	e8 15 36 00 00       	call   80103f10 <wakeup>
801008fb:	83 c4 10             	add    $0x10,%esp
801008fe:	e9 0d ff ff ff       	jmp    80100810 <consoleintr+0x20>
80100903:	90                   	nop
80100904:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100908:	a1 08 00 11 80       	mov    0x80110008,%eax
8010090d:	39 05 04 00 11 80    	cmp    %eax,0x80110004
80100913:	75 2b                	jne    80100940 <consoleintr+0x150>
80100915:	e9 f6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010091a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
        input.e--;
80100920:	a3 08 00 11 80       	mov    %eax,0x80110008
        consputc(BACKSPACE);
80100925:	b8 00 01 00 00       	mov    $0x100,%eax
8010092a:	e8 c1 fa ff ff       	call   801003f0 <consputc>
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
8010092f:	a1 08 00 11 80       	mov    0x80110008,%eax
80100934:	3b 05 04 00 11 80    	cmp    0x80110004,%eax
8010093a:	0f 84 d0 fe ff ff    	je     80100810 <consoleintr+0x20>
            input.buf[(input.e-1) % INPUT_BUF] != '\n'){
80100940:	83 e8 01             	sub    $0x1,%eax
80100943:	89 c2                	mov    %eax,%edx
80100945:	83 e2 7f             	and    $0x7f,%edx
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
      break;
    case C('U'):  // Kill line.
      while(input.e != input.w &&
80100948:	80 ba 80 ff 10 80 0a 	cmpb   $0xa,-0x7fef0080(%edx)
8010094f:	75 cf                	jne    80100920 <consoleintr+0x130>
80100951:	e9 ba fe ff ff       	jmp    80100810 <consoleintr+0x20>
80100956:	8d 76 00             	lea    0x0(%esi),%esi
80100959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  acquire(&cons.lock);
  while((c = getc()) >= 0){
    switch(c){
    case C('P'):  // Process listing.
      // procdump() locks cons.lock indirectly; invoke later
      doprocdump = 1;
80100960:	be 01 00 00 00       	mov    $0x1,%esi
80100965:	e9 a6 fe ff ff       	jmp    80100810 <consoleintr+0x20>
8010096a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
  }
}
80100970:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100973:	5b                   	pop    %ebx
80100974:	5e                   	pop    %esi
80100975:	5f                   	pop    %edi
80100976:	5d                   	pop    %ebp
      break;
    }
  }
  release(&cons.lock);
  if(doprocdump) {
    procdump();  // now call procdump() wo. cons.lock held
80100977:	e9 84 36 00 00       	jmp    80104000 <procdump>
      }
      break;
    default:
      if(c != 0 && input.e-input.r < INPUT_BUF){
        c = (c == '\r') ? '\n' : c;
        input.buf[input.e++ % INPUT_BUF] = c;
8010097c:	c6 80 80 ff 10 80 0a 	movb   $0xa,-0x7fef0080(%eax)
        consputc(c);
80100983:	b8 0a 00 00 00       	mov    $0xa,%eax
80100988:	e8 63 fa ff ff       	call   801003f0 <consputc>
8010098d:	a1 08 00 11 80       	mov    0x80110008,%eax
80100992:	e9 52 ff ff ff       	jmp    801008e9 <consoleintr+0xf9>
80100997:	89 f6                	mov    %esi,%esi
80100999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801009a0 <consoleinit>:
  return n;
}

void
consoleinit(void)
{
801009a0:	55                   	push   %ebp
801009a1:	89 e5                	mov    %esp,%ebp
801009a3:	83 ec 10             	sub    $0x10,%esp
  initlock(&cons.lock, "console");
801009a6:	68 c8 70 10 80       	push   $0x801070c8
801009ab:	68 80 a5 10 80       	push   $0x8010a580
801009b0:	e8 3b 38 00 00       	call   801041f0 <initlock>

  devsw[CONSOLE].write = consolewrite;
  devsw[CONSOLE].read = consoleread;
  cons.locking = 1;

  ioapicenable(IRQ_KBD, 0);
801009b5:	58                   	pop    %eax
801009b6:	5a                   	pop    %edx
801009b7:	6a 00                	push   $0x0
801009b9:	6a 01                	push   $0x1
void
consoleinit(void)
{
  initlock(&cons.lock, "console");

  devsw[CONSOLE].write = consolewrite;
801009bb:	c7 05 cc 09 11 80 00 	movl   $0x80100600,0x801109cc
801009c2:	06 10 80 
  devsw[CONSOLE].read = consoleread;
801009c5:	c7 05 c8 09 11 80 70 	movl   $0x80100270,0x801109c8
801009cc:	02 10 80 
  cons.locking = 1;
801009cf:	c7 05 b4 a5 10 80 01 	movl   $0x1,0x8010a5b4
801009d6:	00 00 00 

  ioapicenable(IRQ_KBD, 0);
801009d9:	e8 c2 18 00 00       	call   801022a0 <ioapicenable>
}
801009de:	83 c4 10             	add    $0x10,%esp
801009e1:	c9                   	leave  
801009e2:	c3                   	ret    
801009e3:	66 90                	xchg   %ax,%ax
801009e5:	66 90                	xchg   %ax,%ax
801009e7:	66 90                	xchg   %ax,%ax
801009e9:	66 90                	xchg   %ax,%ax
801009eb:	66 90                	xchg   %ax,%ax
801009ed:	66 90                	xchg   %ax,%ax
801009ef:	90                   	nop

801009f0 <exec>:
#include "x86.h"
#include "elf.h"

int
exec(char *path, char **argv)
{
801009f0:	55                   	push   %ebp
801009f1:	89 e5                	mov    %esp,%ebp
801009f3:	57                   	push   %edi
801009f4:	56                   	push   %esi
801009f5:	53                   	push   %ebx
801009f6:	81 ec 0c 01 00 00    	sub    $0x10c,%esp
  uint argc, sz, sp, ustack[3+MAXARG+1];
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pde_t *pgdir, *oldpgdir;
  struct proc *curproc = myproc();
801009fc:	e8 9f 2d 00 00       	call   801037a0 <myproc>
80100a01:	89 85 f4 fe ff ff    	mov    %eax,-0x10c(%ebp)

  begin_op();
80100a07:	e8 44 21 00 00       	call   80102b50 <begin_op>

  if((ip = namei(path)) == 0){
80100a0c:	83 ec 0c             	sub    $0xc,%esp
80100a0f:	ff 75 08             	pushl  0x8(%ebp)
80100a12:	e8 a9 14 00 00       	call   80101ec0 <namei>
80100a17:	83 c4 10             	add    $0x10,%esp
80100a1a:	85 c0                	test   %eax,%eax
80100a1c:	0f 84 9c 01 00 00    	je     80100bbe <exec+0x1ce>
    end_op();
    cprintf("exec: fail\n");
    return -1;
  }
  ilock(ip);
80100a22:	83 ec 0c             	sub    $0xc,%esp
80100a25:	89 c3                	mov    %eax,%ebx
80100a27:	50                   	push   %eax
80100a28:	e8 43 0c 00 00       	call   80101670 <ilock>
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
80100a2d:	8d 85 24 ff ff ff    	lea    -0xdc(%ebp),%eax
80100a33:	6a 34                	push   $0x34
80100a35:	6a 00                	push   $0x0
80100a37:	50                   	push   %eax
80100a38:	53                   	push   %ebx
80100a39:	e8 12 0f 00 00       	call   80101950 <readi>
80100a3e:	83 c4 20             	add    $0x20,%esp
80100a41:	83 f8 34             	cmp    $0x34,%eax
80100a44:	74 22                	je     80100a68 <exec+0x78>

 bad:
  if(pgdir)
    freevm(pgdir);
  if(ip){
    iunlockput(ip);
80100a46:	83 ec 0c             	sub    $0xc,%esp
80100a49:	53                   	push   %ebx
80100a4a:	e8 b1 0e 00 00       	call   80101900 <iunlockput>
    end_op();
80100a4f:	e8 6c 21 00 00       	call   80102bc0 <end_op>
80100a54:	83 c4 10             	add    $0x10,%esp
  }
  return -1;
80100a57:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100a5c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100a5f:	5b                   	pop    %ebx
80100a60:	5e                   	pop    %esi
80100a61:	5f                   	pop    %edi
80100a62:	5d                   	pop    %ebp
80100a63:	c3                   	ret    
80100a64:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  pgdir = 0;

  // Check ELF header
  if(readi(ip, (char*)&elf, 0, sizeof(elf)) != sizeof(elf))
    goto bad;
  if(elf.magic != ELF_MAGIC)
80100a68:	81 bd 24 ff ff ff 7f 	cmpl   $0x464c457f,-0xdc(%ebp)
80100a6f:	45 4c 46 
80100a72:	75 d2                	jne    80100a46 <exec+0x56>
    goto bad;

  if((pgdir = setupkvm()) == 0)
80100a74:	e8 37 63 00 00       	call   80106db0 <setupkvm>
80100a79:	85 c0                	test   %eax,%eax
80100a7b:	89 85 f0 fe ff ff    	mov    %eax,-0x110(%ebp)
80100a81:	74 c3                	je     80100a46 <exec+0x56>
    goto bad;

  // Load program into memory.
  sz = 0;
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
80100a83:	66 83 bd 50 ff ff ff 	cmpw   $0x0,-0xb0(%ebp)
80100a8a:	00 
80100a8b:	8b b5 40 ff ff ff    	mov    -0xc0(%ebp),%esi
80100a91:	c7 85 ec fe ff ff 00 	movl   $0x0,-0x114(%ebp)
80100a98:	00 00 00 
80100a9b:	0f 84 c5 00 00 00    	je     80100b66 <exec+0x176>
80100aa1:	31 ff                	xor    %edi,%edi
80100aa3:	eb 18                	jmp    80100abd <exec+0xcd>
80100aa5:	8d 76 00             	lea    0x0(%esi),%esi
80100aa8:	0f b7 85 50 ff ff ff 	movzwl -0xb0(%ebp),%eax
80100aaf:	83 c7 01             	add    $0x1,%edi
80100ab2:	83 c6 20             	add    $0x20,%esi
80100ab5:	39 f8                	cmp    %edi,%eax
80100ab7:	0f 8e a9 00 00 00    	jle    80100b66 <exec+0x176>
    if(readi(ip, (char*)&ph, off, sizeof(ph)) != sizeof(ph))
80100abd:	8d 85 04 ff ff ff    	lea    -0xfc(%ebp),%eax
80100ac3:	6a 20                	push   $0x20
80100ac5:	56                   	push   %esi
80100ac6:	50                   	push   %eax
80100ac7:	53                   	push   %ebx
80100ac8:	e8 83 0e 00 00       	call   80101950 <readi>
80100acd:	83 c4 10             	add    $0x10,%esp
80100ad0:	83 f8 20             	cmp    $0x20,%eax
80100ad3:	75 7b                	jne    80100b50 <exec+0x160>
      goto bad;
    if(ph.type != ELF_PROG_LOAD)
80100ad5:	83 bd 04 ff ff ff 01 	cmpl   $0x1,-0xfc(%ebp)
80100adc:	75 ca                	jne    80100aa8 <exec+0xb8>
      continue;
    if(ph.memsz < ph.filesz)
80100ade:	8b 85 18 ff ff ff    	mov    -0xe8(%ebp),%eax
80100ae4:	3b 85 14 ff ff ff    	cmp    -0xec(%ebp),%eax
80100aea:	72 64                	jb     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr + ph.memsz < ph.vaddr)
80100aec:	03 85 0c ff ff ff    	add    -0xf4(%ebp),%eax
80100af2:	72 5c                	jb     80100b50 <exec+0x160>
      goto bad;
    if((sz = allocuvm(pgdir, sz, ph.vaddr + ph.memsz)) == 0)
80100af4:	83 ec 04             	sub    $0x4,%esp
80100af7:	50                   	push   %eax
80100af8:	ff b5 ec fe ff ff    	pushl  -0x114(%ebp)
80100afe:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b04:	e8 f7 60 00 00       	call   80106c00 <allocuvm>
80100b09:	83 c4 10             	add    $0x10,%esp
80100b0c:	85 c0                	test   %eax,%eax
80100b0e:	89 85 ec fe ff ff    	mov    %eax,-0x114(%ebp)
80100b14:	74 3a                	je     80100b50 <exec+0x160>
      goto bad;
    if(ph.vaddr % PGSIZE != 0)
80100b16:	8b 85 0c ff ff ff    	mov    -0xf4(%ebp),%eax
80100b1c:	a9 ff 0f 00 00       	test   $0xfff,%eax
80100b21:	75 2d                	jne    80100b50 <exec+0x160>
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
80100b23:	83 ec 0c             	sub    $0xc,%esp
80100b26:	ff b5 14 ff ff ff    	pushl  -0xec(%ebp)
80100b2c:	ff b5 08 ff ff ff    	pushl  -0xf8(%ebp)
80100b32:	53                   	push   %ebx
80100b33:	50                   	push   %eax
80100b34:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b3a:	e8 01 60 00 00       	call   80106b40 <loaduvm>
80100b3f:	83 c4 20             	add    $0x20,%esp
80100b42:	85 c0                	test   %eax,%eax
80100b44:	0f 89 5e ff ff ff    	jns    80100aa8 <exec+0xb8>
80100b4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100b50:	83 ec 0c             	sub    $0xc,%esp
80100b53:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b59:	e8 d2 61 00 00       	call   80106d30 <freevm>
80100b5e:	83 c4 10             	add    $0x10,%esp
80100b61:	e9 e0 fe ff ff       	jmp    80100a46 <exec+0x56>
    if(ph.vaddr % PGSIZE != 0)
      goto bad;
    if(loaduvm(pgdir, (char*)ph.vaddr, ip, ph.off, ph.filesz) < 0)
      goto bad;
  }
  iunlockput(ip);
80100b66:	83 ec 0c             	sub    $0xc,%esp
80100b69:	53                   	push   %ebx
80100b6a:	e8 91 0d 00 00       	call   80101900 <iunlockput>
  end_op();
80100b6f:	e8 4c 20 00 00       	call   80102bc0 <end_op>
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b74:	8b 85 ec fe ff ff    	mov    -0x114(%ebp),%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b7a:	83 c4 0c             	add    $0xc,%esp
  end_op();
  ip = 0;

  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
80100b7d:	05 ff 0f 00 00       	add    $0xfff,%eax
80100b82:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
80100b87:	8d 90 00 20 00 00    	lea    0x2000(%eax),%edx
80100b8d:	52                   	push   %edx
80100b8e:	50                   	push   %eax
80100b8f:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100b95:	e8 66 60 00 00       	call   80106c00 <allocuvm>
80100b9a:	83 c4 10             	add    $0x10,%esp
80100b9d:	85 c0                	test   %eax,%eax
80100b9f:	89 c6                	mov    %eax,%esi
80100ba1:	75 3a                	jne    80100bdd <exec+0x1ed>
  freevm(oldpgdir);
  return 0;

 bad:
  if(pgdir)
    freevm(pgdir);
80100ba3:	83 ec 0c             	sub    $0xc,%esp
80100ba6:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bac:	e8 7f 61 00 00       	call   80106d30 <freevm>
80100bb1:	83 c4 10             	add    $0x10,%esp
  if(ip){
    iunlockput(ip);
    end_op();
  }
  return -1;
80100bb4:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bb9:	e9 9e fe ff ff       	jmp    80100a5c <exec+0x6c>
  struct proc *curproc = myproc();

  begin_op();

  if((ip = namei(path)) == 0){
    end_op();
80100bbe:	e8 fd 1f 00 00       	call   80102bc0 <end_op>
    cprintf("exec: fail\n");
80100bc3:	83 ec 0c             	sub    $0xc,%esp
80100bc6:	68 e1 70 10 80       	push   $0x801070e1
80100bcb:	e8 90 fa ff ff       	call   80100660 <cprintf>
    return -1;
80100bd0:	83 c4 10             	add    $0x10,%esp
80100bd3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100bd8:	e9 7f fe ff ff       	jmp    80100a5c <exec+0x6c>
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bdd:	8d 80 00 e0 ff ff    	lea    -0x2000(%eax),%eax
80100be3:	83 ec 08             	sub    $0x8,%esp
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100be6:	31 ff                	xor    %edi,%edi
80100be8:	89 f3                	mov    %esi,%ebx
  // Allocate two pages at the next page boundary.
  // Make the first inaccessible.  Use the second as the user stack.
  sz = PGROUNDUP(sz);
  if((sz = allocuvm(pgdir, sz, sz + 2*PGSIZE)) == 0)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
80100bea:	50                   	push   %eax
80100beb:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
80100bf1:	e8 5a 62 00 00       	call   80106e50 <clearpteu>
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100bf6:	8b 45 0c             	mov    0xc(%ebp),%eax
80100bf9:	83 c4 10             	add    $0x10,%esp
80100bfc:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
80100c02:	8b 00                	mov    (%eax),%eax
80100c04:	85 c0                	test   %eax,%eax
80100c06:	74 79                	je     80100c81 <exec+0x291>
80100c08:	89 b5 ec fe ff ff    	mov    %esi,-0x114(%ebp)
80100c0e:	8b b5 f0 fe ff ff    	mov    -0x110(%ebp),%esi
80100c14:	eb 13                	jmp    80100c29 <exec+0x239>
80100c16:	8d 76 00             	lea    0x0(%esi),%esi
80100c19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(argc >= MAXARG)
80100c20:	83 ff 20             	cmp    $0x20,%edi
80100c23:	0f 84 7a ff ff ff    	je     80100ba3 <exec+0x1b3>
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c29:	83 ec 0c             	sub    $0xc,%esp
80100c2c:	50                   	push   %eax
80100c2d:	e8 5e 3a 00 00       	call   80104690 <strlen>
80100c32:	f7 d0                	not    %eax
80100c34:	01 c3                	add    %eax,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c36:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c39:	5a                   	pop    %edx

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
80100c3a:	83 e3 fc             	and    $0xfffffffc,%ebx
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
80100c3d:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c40:	e8 4b 3a 00 00       	call   80104690 <strlen>
80100c45:	83 c0 01             	add    $0x1,%eax
80100c48:	50                   	push   %eax
80100c49:	8b 45 0c             	mov    0xc(%ebp),%eax
80100c4c:	ff 34 b8             	pushl  (%eax,%edi,4)
80100c4f:	53                   	push   %ebx
80100c50:	56                   	push   %esi
80100c51:	e8 6a 63 00 00       	call   80106fc0 <copyout>
80100c56:	83 c4 20             	add    $0x20,%esp
80100c59:	85 c0                	test   %eax,%eax
80100c5b:	0f 88 42 ff ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c61:	8b 45 0c             	mov    0xc(%ebp),%eax
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c64:	89 9c bd 64 ff ff ff 	mov    %ebx,-0x9c(%ebp,%edi,4)
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c6b:	83 c7 01             	add    $0x1,%edi
    if(argc >= MAXARG)
      goto bad;
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
80100c6e:	8d 95 58 ff ff ff    	lea    -0xa8(%ebp),%edx
    goto bad;
  clearpteu(pgdir, (char*)(sz - 2*PGSIZE));
  sp = sz;

  // Push argument strings, prepare rest of stack in ustack.
  for(argc = 0; argv[argc]; argc++) {
80100c74:	8b 04 b8             	mov    (%eax,%edi,4),%eax
80100c77:	85 c0                	test   %eax,%eax
80100c79:	75 a5                	jne    80100c20 <exec+0x230>
80100c7b:	8b b5 ec fe ff ff    	mov    -0x114(%ebp),%esi
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100c81:	8d 04 bd 04 00 00 00 	lea    0x4(,%edi,4),%eax
80100c88:	89 d9                	mov    %ebx,%ecx
    sp = (sp - (strlen(argv[argc]) + 1)) & ~3;
    if(copyout(pgdir, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
      goto bad;
    ustack[3+argc] = sp;
  }
  ustack[3+argc] = 0;
80100c8a:	c7 84 bd 64 ff ff ff 	movl   $0x0,-0x9c(%ebp,%edi,4)
80100c91:	00 00 00 00 

  ustack[0] = 0xffffffff;  // fake return PC
80100c95:	c7 85 58 ff ff ff ff 	movl   $0xffffffff,-0xa8(%ebp)
80100c9c:	ff ff ff 
  ustack[1] = argc;
80100c9f:	89 bd 5c ff ff ff    	mov    %edi,-0xa4(%ebp)
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100ca5:	29 c1                	sub    %eax,%ecx

  sp -= (3+argc+1) * 4;
80100ca7:	83 c0 0c             	add    $0xc,%eax
80100caa:	29 c3                	sub    %eax,%ebx
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cac:	50                   	push   %eax
80100cad:	52                   	push   %edx
80100cae:	53                   	push   %ebx
80100caf:	ff b5 f0 fe ff ff    	pushl  -0x110(%ebp)
  }
  ustack[3+argc] = 0;

  ustack[0] = 0xffffffff;  // fake return PC
  ustack[1] = argc;
  ustack[2] = sp - (argc+1)*4;  // argv pointer
80100cb5:	89 8d 60 ff ff ff    	mov    %ecx,-0xa0(%ebp)

  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
80100cbb:	e8 00 63 00 00       	call   80106fc0 <copyout>
80100cc0:	83 c4 10             	add    $0x10,%esp
80100cc3:	85 c0                	test   %eax,%eax
80100cc5:	0f 88 d8 fe ff ff    	js     80100ba3 <exec+0x1b3>
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ccb:	8b 45 08             	mov    0x8(%ebp),%eax
80100cce:	0f b6 10             	movzbl (%eax),%edx
80100cd1:	84 d2                	test   %dl,%dl
80100cd3:	74 19                	je     80100cee <exec+0x2fe>
80100cd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
80100cd8:	83 c0 01             	add    $0x1,%eax
    if(*s == '/')
      last = s+1;
80100cdb:	80 fa 2f             	cmp    $0x2f,%dl
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100cde:	0f b6 10             	movzbl (%eax),%edx
    if(*s == '/')
      last = s+1;
80100ce1:	0f 44 c8             	cmove  %eax,%ecx
80100ce4:	83 c0 01             	add    $0x1,%eax
  sp -= (3+argc+1) * 4;
  if(copyout(pgdir, sp, ustack, (3+argc+1)*4) < 0)
    goto bad;

  // Save program name for debugging.
  for(last=s=path; *s; s++)
80100ce7:	84 d2                	test   %dl,%dl
80100ce9:	75 f0                	jne    80100cdb <exec+0x2eb>
80100ceb:	89 4d 08             	mov    %ecx,0x8(%ebp)
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));
80100cee:	8b bd f4 fe ff ff    	mov    -0x10c(%ebp),%edi
80100cf4:	50                   	push   %eax
80100cf5:	6a 10                	push   $0x10
80100cf7:	ff 75 08             	pushl  0x8(%ebp)
80100cfa:	89 f8                	mov    %edi,%eax
80100cfc:	83 c0 74             	add    $0x74,%eax
80100cff:	50                   	push   %eax
80100d00:	e8 4b 39 00 00       	call   80104650 <safestrcpy>

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d05:	8b 8d f0 fe ff ff    	mov    -0x110(%ebp),%ecx
    if(*s == '/')
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
80100d0b:	89 f8                	mov    %edi,%eax
80100d0d:	8b 7f 0c             	mov    0xc(%edi),%edi
  curproc->pgdir = pgdir;
  curproc->sz = sz;
80100d10:	89 30                	mov    %esi,(%eax)
      last = s+1;
  safestrcpy(curproc->name, last, sizeof(curproc->name));

  // Commit to the user image.
  oldpgdir = curproc->pgdir;
  curproc->pgdir = pgdir;
80100d12:	89 48 0c             	mov    %ecx,0xc(%eax)
  curproc->sz = sz;
  curproc->tf->eip = elf.entry;  // main
80100d15:	89 c1                	mov    %eax,%ecx
80100d17:	8b 95 3c ff ff ff    	mov    -0xc4(%ebp),%edx
80100d1d:	8b 40 20             	mov    0x20(%eax),%eax
80100d20:	89 50 38             	mov    %edx,0x38(%eax)
  curproc->tf->esp = sp;
80100d23:	8b 41 20             	mov    0x20(%ecx),%eax
80100d26:	89 58 44             	mov    %ebx,0x44(%eax)
  switchuvm(curproc);
80100d29:	89 0c 24             	mov    %ecx,(%esp)
80100d2c:	e8 7f 5c 00 00       	call   801069b0 <switchuvm>
  freevm(oldpgdir);
80100d31:	89 3c 24             	mov    %edi,(%esp)
80100d34:	e8 f7 5f 00 00       	call   80106d30 <freevm>
  return 0;
80100d39:	83 c4 10             	add    $0x10,%esp
80100d3c:	31 c0                	xor    %eax,%eax
80100d3e:	e9 19 fd ff ff       	jmp    80100a5c <exec+0x6c>
80100d43:	66 90                	xchg   %ax,%ax
80100d45:	66 90                	xchg   %ax,%ax
80100d47:	66 90                	xchg   %ax,%ax
80100d49:	66 90                	xchg   %ax,%ax
80100d4b:	66 90                	xchg   %ax,%ax
80100d4d:	66 90                	xchg   %ax,%ax
80100d4f:	90                   	nop

80100d50 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
80100d50:	55                   	push   %ebp
80100d51:	89 e5                	mov    %esp,%ebp
80100d53:	83 ec 10             	sub    $0x10,%esp
  initlock(&ftable.lock, "ftable");
80100d56:	68 ed 70 10 80       	push   $0x801070ed
80100d5b:	68 20 00 11 80       	push   $0x80110020
80100d60:	e8 8b 34 00 00       	call   801041f0 <initlock>
}
80100d65:	83 c4 10             	add    $0x10,%esp
80100d68:	c9                   	leave  
80100d69:	c3                   	ret    
80100d6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100d70 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d70:	55                   	push   %ebp
80100d71:	89 e5                	mov    %esp,%ebp
80100d73:	53                   	push   %ebx
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d74:	bb 54 00 11 80       	mov    $0x80110054,%ebx
}

// Allocate a file structure.
struct file*
filealloc(void)
{
80100d79:	83 ec 10             	sub    $0x10,%esp
  struct file *f;

  acquire(&ftable.lock);
80100d7c:	68 20 00 11 80       	push   $0x80110020
80100d81:	e8 ca 35 00 00       	call   80104350 <acquire>
80100d86:	83 c4 10             	add    $0x10,%esp
80100d89:	eb 10                	jmp    80100d9b <filealloc+0x2b>
80100d8b:	90                   	nop
80100d8c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(f = ftable.file; f < ftable.file + NFILE; f++){
80100d90:	83 c3 18             	add    $0x18,%ebx
80100d93:	81 fb b4 09 11 80    	cmp    $0x801109b4,%ebx
80100d99:	74 25                	je     80100dc0 <filealloc+0x50>
    if(f->ref == 0){
80100d9b:	8b 43 04             	mov    0x4(%ebx),%eax
80100d9e:	85 c0                	test   %eax,%eax
80100da0:	75 ee                	jne    80100d90 <filealloc+0x20>
      f->ref = 1;
      release(&ftable.lock);
80100da2:	83 ec 0c             	sub    $0xc,%esp
  struct file *f;

  acquire(&ftable.lock);
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    if(f->ref == 0){
      f->ref = 1;
80100da5:	c7 43 04 01 00 00 00 	movl   $0x1,0x4(%ebx)
      release(&ftable.lock);
80100dac:	68 20 00 11 80       	push   $0x80110020
80100db1:	e8 4a 36 00 00       	call   80104400 <release>
      return f;
80100db6:	89 d8                	mov    %ebx,%eax
80100db8:	83 c4 10             	add    $0x10,%esp
    }
  }
  release(&ftable.lock);
  return 0;
}
80100dbb:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dbe:	c9                   	leave  
80100dbf:	c3                   	ret    
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
80100dc0:	83 ec 0c             	sub    $0xc,%esp
80100dc3:	68 20 00 11 80       	push   $0x80110020
80100dc8:	e8 33 36 00 00       	call   80104400 <release>
  return 0;
80100dcd:	83 c4 10             	add    $0x10,%esp
80100dd0:	31 c0                	xor    %eax,%eax
}
80100dd2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100dd5:	c9                   	leave  
80100dd6:	c3                   	ret    
80100dd7:	89 f6                	mov    %esi,%esi
80100dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100de0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
80100de0:	55                   	push   %ebp
80100de1:	89 e5                	mov    %esp,%ebp
80100de3:	53                   	push   %ebx
80100de4:	83 ec 10             	sub    $0x10,%esp
80100de7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ftable.lock);
80100dea:	68 20 00 11 80       	push   $0x80110020
80100def:	e8 5c 35 00 00       	call   80104350 <acquire>
  if(f->ref < 1)
80100df4:	8b 43 04             	mov    0x4(%ebx),%eax
80100df7:	83 c4 10             	add    $0x10,%esp
80100dfa:	85 c0                	test   %eax,%eax
80100dfc:	7e 1a                	jle    80100e18 <filedup+0x38>
    panic("filedup");
  f->ref++;
80100dfe:	83 c0 01             	add    $0x1,%eax
  release(&ftable.lock);
80100e01:	83 ec 0c             	sub    $0xc,%esp
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
  f->ref++;
80100e04:	89 43 04             	mov    %eax,0x4(%ebx)
  release(&ftable.lock);
80100e07:	68 20 00 11 80       	push   $0x80110020
80100e0c:	e8 ef 35 00 00       	call   80104400 <release>
  return f;
}
80100e11:	89 d8                	mov    %ebx,%eax
80100e13:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100e16:	c9                   	leave  
80100e17:	c3                   	ret    
struct file*
filedup(struct file *f)
{
  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("filedup");
80100e18:	83 ec 0c             	sub    $0xc,%esp
80100e1b:	68 f4 70 10 80       	push   $0x801070f4
80100e20:	e8 4b f5 ff ff       	call   80100370 <panic>
80100e25:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80100e29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80100e30 <fileclose>:
}

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
80100e30:	55                   	push   %ebp
80100e31:	89 e5                	mov    %esp,%ebp
80100e33:	57                   	push   %edi
80100e34:	56                   	push   %esi
80100e35:	53                   	push   %ebx
80100e36:	83 ec 28             	sub    $0x28,%esp
80100e39:	8b 7d 08             	mov    0x8(%ebp),%edi
  struct file ff;

  acquire(&ftable.lock);
80100e3c:	68 20 00 11 80       	push   $0x80110020
80100e41:	e8 0a 35 00 00       	call   80104350 <acquire>
  if(f->ref < 1)
80100e46:	8b 47 04             	mov    0x4(%edi),%eax
80100e49:	83 c4 10             	add    $0x10,%esp
80100e4c:	85 c0                	test   %eax,%eax
80100e4e:	0f 8e 9b 00 00 00    	jle    80100eef <fileclose+0xbf>
    panic("fileclose");
  if(--f->ref > 0){
80100e54:	83 e8 01             	sub    $0x1,%eax
80100e57:	85 c0                	test   %eax,%eax
80100e59:	89 47 04             	mov    %eax,0x4(%edi)
80100e5c:	74 1a                	je     80100e78 <fileclose+0x48>
    release(&ftable.lock);
80100e5e:	c7 45 08 20 00 11 80 	movl   $0x80110020,0x8(%ebp)
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100e65:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100e68:	5b                   	pop    %ebx
80100e69:	5e                   	pop    %esi
80100e6a:	5f                   	pop    %edi
80100e6b:	5d                   	pop    %ebp

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
80100e6c:	e9 8f 35 00 00       	jmp    80104400 <release>
80100e71:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return;
  }
  ff = *f;
80100e78:	0f b6 47 09          	movzbl 0x9(%edi),%eax
80100e7c:	8b 1f                	mov    (%edi),%ebx
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e7e:	83 ec 0c             	sub    $0xc,%esp
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e81:	8b 77 0c             	mov    0xc(%edi),%esi
  f->ref = 0;
  f->type = FD_NONE;
80100e84:	c7 07 00 00 00 00    	movl   $0x0,(%edi)
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e8a:	88 45 e7             	mov    %al,-0x19(%ebp)
80100e8d:	8b 47 10             	mov    0x10(%edi),%eax
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e90:	68 20 00 11 80       	push   $0x80110020
    panic("fileclose");
  if(--f->ref > 0){
    release(&ftable.lock);
    return;
  }
  ff = *f;
80100e95:	89 45 e0             	mov    %eax,-0x20(%ebp)
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);
80100e98:	e8 63 35 00 00       	call   80104400 <release>

  if(ff.type == FD_PIPE)
80100e9d:	83 c4 10             	add    $0x10,%esp
80100ea0:	83 fb 01             	cmp    $0x1,%ebx
80100ea3:	74 13                	je     80100eb8 <fileclose+0x88>
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
80100ea5:	83 fb 02             	cmp    $0x2,%ebx
80100ea8:	74 26                	je     80100ed0 <fileclose+0xa0>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
80100eaa:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ead:	5b                   	pop    %ebx
80100eae:	5e                   	pop    %esi
80100eaf:	5f                   	pop    %edi
80100eb0:	5d                   	pop    %ebp
80100eb1:	c3                   	ret    
80100eb2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  f->ref = 0;
  f->type = FD_NONE;
  release(&ftable.lock);

  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
80100eb8:	0f be 5d e7          	movsbl -0x19(%ebp),%ebx
80100ebc:	83 ec 08             	sub    $0x8,%esp
80100ebf:	53                   	push   %ebx
80100ec0:	56                   	push   %esi
80100ec1:	e8 2a 24 00 00       	call   801032f0 <pipeclose>
80100ec6:	83 c4 10             	add    $0x10,%esp
80100ec9:	eb df                	jmp    80100eaa <fileclose+0x7a>
80100ecb:	90                   	nop
80100ecc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  else if(ff.type == FD_INODE){
    begin_op();
80100ed0:	e8 7b 1c 00 00       	call   80102b50 <begin_op>
    iput(ff.ip);
80100ed5:	83 ec 0c             	sub    $0xc,%esp
80100ed8:	ff 75 e0             	pushl  -0x20(%ebp)
80100edb:	e8 c0 08 00 00       	call   801017a0 <iput>
    end_op();
80100ee0:	83 c4 10             	add    $0x10,%esp
  }
}
80100ee3:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100ee6:	5b                   	pop    %ebx
80100ee7:	5e                   	pop    %esi
80100ee8:	5f                   	pop    %edi
80100ee9:	5d                   	pop    %ebp
  if(ff.type == FD_PIPE)
    pipeclose(ff.pipe, ff.writable);
  else if(ff.type == FD_INODE){
    begin_op();
    iput(ff.ip);
    end_op();
80100eea:	e9 d1 1c 00 00       	jmp    80102bc0 <end_op>
{
  struct file ff;

  acquire(&ftable.lock);
  if(f->ref < 1)
    panic("fileclose");
80100eef:	83 ec 0c             	sub    $0xc,%esp
80100ef2:	68 fc 70 10 80       	push   $0x801070fc
80100ef7:	e8 74 f4 ff ff       	call   80100370 <panic>
80100efc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100f00 <filestat>:
}

// Get metadata about file f.
int
filestat(struct file *f, struct stat *st)
{
80100f00:	55                   	push   %ebp
80100f01:	89 e5                	mov    %esp,%ebp
80100f03:	53                   	push   %ebx
80100f04:	83 ec 04             	sub    $0x4,%esp
80100f07:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(f->type == FD_INODE){
80100f0a:	83 3b 02             	cmpl   $0x2,(%ebx)
80100f0d:	75 31                	jne    80100f40 <filestat+0x40>
    ilock(f->ip);
80100f0f:	83 ec 0c             	sub    $0xc,%esp
80100f12:	ff 73 10             	pushl  0x10(%ebx)
80100f15:	e8 56 07 00 00       	call   80101670 <ilock>
    stati(f->ip, st);
80100f1a:	58                   	pop    %eax
80100f1b:	5a                   	pop    %edx
80100f1c:	ff 75 0c             	pushl  0xc(%ebp)
80100f1f:	ff 73 10             	pushl  0x10(%ebx)
80100f22:	e8 f9 09 00 00       	call   80101920 <stati>
    iunlock(f->ip);
80100f27:	59                   	pop    %ecx
80100f28:	ff 73 10             	pushl  0x10(%ebx)
80100f2b:	e8 20 08 00 00       	call   80101750 <iunlock>
    return 0;
80100f30:	83 c4 10             	add    $0x10,%esp
80100f33:	31 c0                	xor    %eax,%eax
  }
  return -1;
}
80100f35:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f38:	c9                   	leave  
80100f39:	c3                   	ret    
80100f3a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    ilock(f->ip);
    stati(f->ip, st);
    iunlock(f->ip);
    return 0;
  }
  return -1;
80100f40:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80100f45:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80100f48:	c9                   	leave  
80100f49:	c3                   	ret    
80100f4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80100f50 <fileread>:

// Read from file f.
int
fileread(struct file *f, char *addr, int n)
{
80100f50:	55                   	push   %ebp
80100f51:	89 e5                	mov    %esp,%ebp
80100f53:	57                   	push   %edi
80100f54:	56                   	push   %esi
80100f55:	53                   	push   %ebx
80100f56:	83 ec 0c             	sub    $0xc,%esp
80100f59:	8b 5d 08             	mov    0x8(%ebp),%ebx
80100f5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80100f5f:	8b 7d 10             	mov    0x10(%ebp),%edi
  int r;

  if(f->readable == 0)
80100f62:	80 7b 08 00          	cmpb   $0x0,0x8(%ebx)
80100f66:	74 60                	je     80100fc8 <fileread+0x78>
    return -1;
  if(f->type == FD_PIPE)
80100f68:	8b 03                	mov    (%ebx),%eax
80100f6a:	83 f8 01             	cmp    $0x1,%eax
80100f6d:	74 41                	je     80100fb0 <fileread+0x60>
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
80100f6f:	83 f8 02             	cmp    $0x2,%eax
80100f72:	75 5b                	jne    80100fcf <fileread+0x7f>
    ilock(f->ip);
80100f74:	83 ec 0c             	sub    $0xc,%esp
80100f77:	ff 73 10             	pushl  0x10(%ebx)
80100f7a:	e8 f1 06 00 00       	call   80101670 <ilock>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100f7f:	57                   	push   %edi
80100f80:	ff 73 14             	pushl  0x14(%ebx)
80100f83:	56                   	push   %esi
80100f84:	ff 73 10             	pushl  0x10(%ebx)
80100f87:	e8 c4 09 00 00       	call   80101950 <readi>
80100f8c:	83 c4 20             	add    $0x20,%esp
80100f8f:	85 c0                	test   %eax,%eax
80100f91:	89 c6                	mov    %eax,%esi
80100f93:	7e 03                	jle    80100f98 <fileread+0x48>
      f->off += r;
80100f95:	01 43 14             	add    %eax,0x14(%ebx)
    iunlock(f->ip);
80100f98:	83 ec 0c             	sub    $0xc,%esp
80100f9b:	ff 73 10             	pushl  0x10(%ebx)
80100f9e:	e8 ad 07 00 00       	call   80101750 <iunlock>
    return r;
80100fa3:	83 c4 10             	add    $0x10,%esp
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
  if(f->type == FD_INODE){
    ilock(f->ip);
    if((r = readi(f->ip, addr, f->off, n)) > 0)
80100fa6:	89 f0                	mov    %esi,%eax
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fa8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fab:	5b                   	pop    %ebx
80100fac:	5e                   	pop    %esi
80100fad:	5f                   	pop    %edi
80100fae:	5d                   	pop    %ebp
80100faf:	c3                   	ret    
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fb0:	8b 43 0c             	mov    0xc(%ebx),%eax
80100fb3:	89 45 08             	mov    %eax,0x8(%ebp)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
}
80100fb6:	8d 65 f4             	lea    -0xc(%ebp),%esp
80100fb9:	5b                   	pop    %ebx
80100fba:	5e                   	pop    %esi
80100fbb:	5f                   	pop    %edi
80100fbc:	5d                   	pop    %ebp
  int r;

  if(f->readable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return piperead(f->pipe, addr, n);
80100fbd:	e9 ce 24 00 00       	jmp    80103490 <piperead>
80100fc2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
fileread(struct file *f, char *addr, int n)
{
  int r;

  if(f->readable == 0)
    return -1;
80100fc8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80100fcd:	eb d9                	jmp    80100fa8 <fileread+0x58>
    if((r = readi(f->ip, addr, f->off, n)) > 0)
      f->off += r;
    iunlock(f->ip);
    return r;
  }
  panic("fileread");
80100fcf:	83 ec 0c             	sub    $0xc,%esp
80100fd2:	68 06 71 10 80       	push   $0x80107106
80100fd7:	e8 94 f3 ff ff       	call   80100370 <panic>
80100fdc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80100fe0 <filewrite>:

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100fe0:	55                   	push   %ebp
80100fe1:	89 e5                	mov    %esp,%ebp
80100fe3:	57                   	push   %edi
80100fe4:	56                   	push   %esi
80100fe5:	53                   	push   %ebx
80100fe6:	83 ec 1c             	sub    $0x1c,%esp
80100fe9:	8b 75 08             	mov    0x8(%ebp),%esi
80100fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  int r;

  if(f->writable == 0)
80100fef:	80 7e 09 00          	cmpb   $0x0,0x9(%esi)

//PAGEBREAK!
// Write to file f.
int
filewrite(struct file *f, char *addr, int n)
{
80100ff3:	89 45 dc             	mov    %eax,-0x24(%ebp)
80100ff6:	8b 45 10             	mov    0x10(%ebp),%eax
80100ff9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int r;

  if(f->writable == 0)
80100ffc:	0f 84 aa 00 00 00    	je     801010ac <filewrite+0xcc>
    return -1;
  if(f->type == FD_PIPE)
80101002:	8b 06                	mov    (%esi),%eax
80101004:	83 f8 01             	cmp    $0x1,%eax
80101007:	0f 84 c2 00 00 00    	je     801010cf <filewrite+0xef>
    return pipewrite(f->pipe, addr, n);
  if(f->type == FD_INODE){
8010100d:	83 f8 02             	cmp    $0x2,%eax
80101010:	0f 85 d8 00 00 00    	jne    801010ee <filewrite+0x10e>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
80101016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101019:	31 ff                	xor    %edi,%edi
8010101b:	85 c0                	test   %eax,%eax
8010101d:	7f 34                	jg     80101053 <filewrite+0x73>
8010101f:	e9 9c 00 00 00       	jmp    801010c0 <filewrite+0xe0>
80101024:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101028:	01 46 14             	add    %eax,0x14(%esi)
      iunlock(f->ip);
8010102b:	83 ec 0c             	sub    $0xc,%esp
8010102e:	ff 76 10             	pushl  0x10(%esi)
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
        f->off += r;
80101031:	89 45 e0             	mov    %eax,-0x20(%ebp)
      iunlock(f->ip);
80101034:	e8 17 07 00 00       	call   80101750 <iunlock>
      end_op();
80101039:	e8 82 1b 00 00       	call   80102bc0 <end_op>
8010103e:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101041:	83 c4 10             	add    $0x10,%esp

      if(r < 0)
        break;
      if(r != n1)
80101044:	39 d8                	cmp    %ebx,%eax
80101046:	0f 85 95 00 00 00    	jne    801010e1 <filewrite+0x101>
        panic("short filewrite");
      i += r;
8010104c:	01 c7                	add    %eax,%edi
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * 512;
    int i = 0;
    while(i < n){
8010104e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101051:	7e 6d                	jle    801010c0 <filewrite+0xe0>
      int n1 = n - i;
80101053:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
80101056:	b8 00 06 00 00       	mov    $0x600,%eax
8010105b:	29 fb                	sub    %edi,%ebx
8010105d:	81 fb 00 06 00 00    	cmp    $0x600,%ebx
80101063:	0f 4f d8             	cmovg  %eax,%ebx
      if(n1 > max)
        n1 = max;

      begin_op();
80101066:	e8 e5 1a 00 00       	call   80102b50 <begin_op>
      ilock(f->ip);
8010106b:	83 ec 0c             	sub    $0xc,%esp
8010106e:	ff 76 10             	pushl  0x10(%esi)
80101071:	e8 fa 05 00 00       	call   80101670 <ilock>
      if ((r = writei(f->ip, addr + i, f->off, n1)) > 0)
80101076:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101079:	53                   	push   %ebx
8010107a:	ff 76 14             	pushl  0x14(%esi)
8010107d:	01 f8                	add    %edi,%eax
8010107f:	50                   	push   %eax
80101080:	ff 76 10             	pushl  0x10(%esi)
80101083:	e8 c8 09 00 00       	call   80101a50 <writei>
80101088:	83 c4 20             	add    $0x20,%esp
8010108b:	85 c0                	test   %eax,%eax
8010108d:	7f 99                	jg     80101028 <filewrite+0x48>
        f->off += r;
      iunlock(f->ip);
8010108f:	83 ec 0c             	sub    $0xc,%esp
80101092:	ff 76 10             	pushl  0x10(%esi)
80101095:	89 45 e0             	mov    %eax,-0x20(%ebp)
80101098:	e8 b3 06 00 00       	call   80101750 <iunlock>
      end_op();
8010109d:	e8 1e 1b 00 00       	call   80102bc0 <end_op>

      if(r < 0)
801010a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
801010a5:	83 c4 10             	add    $0x10,%esp
801010a8:	85 c0                	test   %eax,%eax
801010aa:	74 98                	je     80101044 <filewrite+0x64>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010ac:	8d 65 f4             	lea    -0xc(%ebp),%esp
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010af:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  panic("filewrite");
}
801010b4:	5b                   	pop    %ebx
801010b5:	5e                   	pop    %esi
801010b6:	5f                   	pop    %edi
801010b7:	5d                   	pop    %ebp
801010b8:	c3                   	ret    
801010b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
        break;
      if(r != n1)
        panic("short filewrite");
      i += r;
    }
    return i == n ? n : -1;
801010c0:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
801010c3:	75 e7                	jne    801010ac <filewrite+0xcc>
  }
  panic("filewrite");
}
801010c5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010c8:	89 f8                	mov    %edi,%eax
801010ca:	5b                   	pop    %ebx
801010cb:	5e                   	pop    %esi
801010cc:	5f                   	pop    %edi
801010cd:	5d                   	pop    %ebp
801010ce:	c3                   	ret    
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010cf:	8b 46 0c             	mov    0xc(%esi),%eax
801010d2:	89 45 08             	mov    %eax,0x8(%ebp)
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
}
801010d5:	8d 65 f4             	lea    -0xc(%ebp),%esp
801010d8:	5b                   	pop    %ebx
801010d9:	5e                   	pop    %esi
801010da:	5f                   	pop    %edi
801010db:	5d                   	pop    %ebp
  int r;

  if(f->writable == 0)
    return -1;
  if(f->type == FD_PIPE)
    return pipewrite(f->pipe, addr, n);
801010dc:	e9 af 22 00 00       	jmp    80103390 <pipewrite>
      end_op();

      if(r < 0)
        break;
      if(r != n1)
        panic("short filewrite");
801010e1:	83 ec 0c             	sub    $0xc,%esp
801010e4:	68 0f 71 10 80       	push   $0x8010710f
801010e9:	e8 82 f2 ff ff       	call   80100370 <panic>
      i += r;
    }
    return i == n ? n : -1;
  }
  panic("filewrite");
801010ee:	83 ec 0c             	sub    $0xc,%esp
801010f1:	68 15 71 10 80       	push   $0x80107115
801010f6:	e8 75 f2 ff ff       	call   80100370 <panic>
801010fb:	66 90                	xchg   %ax,%ax
801010fd:	66 90                	xchg   %ax,%ax
801010ff:	90                   	nop

80101100 <balloc>:
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
80101100:	55                   	push   %ebp
80101101:	89 e5                	mov    %esp,%ebp
80101103:	57                   	push   %edi
80101104:	56                   	push   %esi
80101105:	53                   	push   %ebx
80101106:	83 ec 1c             	sub    $0x1c,%esp
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101109:	8b 0d 20 0a 11 80    	mov    0x80110a20,%ecx
// Blocks.

// Allocate a zeroed disk block.
static uint
balloc(uint dev)
{
8010110f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
80101112:	85 c9                	test   %ecx,%ecx
80101114:	0f 84 85 00 00 00    	je     8010119f <balloc+0x9f>
8010111a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    bp = bread(dev, BBLOCK(b, sb));
80101121:	8b 75 dc             	mov    -0x24(%ebp),%esi
80101124:	83 ec 08             	sub    $0x8,%esp
80101127:	89 f0                	mov    %esi,%eax
80101129:	c1 f8 0c             	sar    $0xc,%eax
8010112c:	03 05 38 0a 11 80    	add    0x80110a38,%eax
80101132:	50                   	push   %eax
80101133:	ff 75 d8             	pushl  -0x28(%ebp)
80101136:	e8 95 ef ff ff       	call   801000d0 <bread>
8010113b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010113e:	a1 20 0a 11 80       	mov    0x80110a20,%eax
80101143:	83 c4 10             	add    $0x10,%esp
80101146:	89 45 e0             	mov    %eax,-0x20(%ebp)
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
80101149:	31 c0                	xor    %eax,%eax
8010114b:	eb 2d                	jmp    8010117a <balloc+0x7a>
8010114d:	8d 76 00             	lea    0x0(%esi),%esi
      m = 1 << (bi % 8);
80101150:	89 c1                	mov    %eax,%ecx
80101152:	ba 01 00 00 00       	mov    $0x1,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
80101157:	8b 5d e4             	mov    -0x1c(%ebp),%ebx

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
8010115a:	83 e1 07             	and    $0x7,%ecx
8010115d:	d3 e2                	shl    %cl,%edx
      if((bp->data[bi/8] & m) == 0){  // Is block free?
8010115f:	89 c1                	mov    %eax,%ecx
80101161:	c1 f9 03             	sar    $0x3,%ecx
80101164:	0f b6 7c 0b 5c       	movzbl 0x5c(%ebx,%ecx,1),%edi
80101169:	85 d7                	test   %edx,%edi
8010116b:	74 43                	je     801011b0 <balloc+0xb0>
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
8010116d:	83 c0 01             	add    $0x1,%eax
80101170:	83 c6 01             	add    $0x1,%esi
80101173:	3d 00 10 00 00       	cmp    $0x1000,%eax
80101178:	74 05                	je     8010117f <balloc+0x7f>
8010117a:	3b 75 e0             	cmp    -0x20(%ebp),%esi
8010117d:	72 d1                	jb     80101150 <balloc+0x50>
        brelse(bp);
        bzero(dev, b + bi);
        return b + bi;
      }
    }
    brelse(bp);
8010117f:	83 ec 0c             	sub    $0xc,%esp
80101182:	ff 75 e4             	pushl  -0x1c(%ebp)
80101185:	e8 56 f0 ff ff       	call   801001e0 <brelse>
{
  int b, bi, m;
  struct buf *bp;

  bp = 0;
  for(b = 0; b < sb.size; b += BPB){
8010118a:	81 45 dc 00 10 00 00 	addl   $0x1000,-0x24(%ebp)
80101191:	83 c4 10             	add    $0x10,%esp
80101194:	8b 45 dc             	mov    -0x24(%ebp),%eax
80101197:	39 05 20 0a 11 80    	cmp    %eax,0x80110a20
8010119d:	77 82                	ja     80101121 <balloc+0x21>
        return b + bi;
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
8010119f:	83 ec 0c             	sub    $0xc,%esp
801011a2:	68 1f 71 10 80       	push   $0x8010711f
801011a7:	e8 c4 f1 ff ff       	call   80100370 <panic>
801011ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b0:	09 fa                	or     %edi,%edx
801011b2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
        log_write(bp);
801011b5:	83 ec 0c             	sub    $0xc,%esp
  for(b = 0; b < sb.size; b += BPB){
    bp = bread(dev, BBLOCK(b, sb));
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
      m = 1 << (bi % 8);
      if((bp->data[bi/8] & m) == 0){  // Is block free?
        bp->data[bi/8] |= m;  // Mark block in use.
801011b8:	88 54 0f 5c          	mov    %dl,0x5c(%edi,%ecx,1)
        log_write(bp);
801011bc:	57                   	push   %edi
801011bd:	e8 6e 1b 00 00       	call   80102d30 <log_write>
        brelse(bp);
801011c2:	89 3c 24             	mov    %edi,(%esp)
801011c5:	e8 16 f0 ff ff       	call   801001e0 <brelse>
static void
bzero(int dev, int bno)
{
  struct buf *bp;

  bp = bread(dev, bno);
801011ca:	58                   	pop    %eax
801011cb:	5a                   	pop    %edx
801011cc:	56                   	push   %esi
801011cd:	ff 75 d8             	pushl  -0x28(%ebp)
801011d0:	e8 fb ee ff ff       	call   801000d0 <bread>
801011d5:	89 c3                	mov    %eax,%ebx
  memset(bp->data, 0, BSIZE);
801011d7:	8d 40 5c             	lea    0x5c(%eax),%eax
801011da:	83 c4 0c             	add    $0xc,%esp
801011dd:	68 00 02 00 00       	push   $0x200
801011e2:	6a 00                	push   $0x0
801011e4:	50                   	push   %eax
801011e5:	e8 66 32 00 00       	call   80104450 <memset>
  log_write(bp);
801011ea:	89 1c 24             	mov    %ebx,(%esp)
801011ed:	e8 3e 1b 00 00       	call   80102d30 <log_write>
  brelse(bp);
801011f2:	89 1c 24             	mov    %ebx,(%esp)
801011f5:	e8 e6 ef ff ff       	call   801001e0 <brelse>
      }
    }
    brelse(bp);
  }
  panic("balloc: out of blocks");
}
801011fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801011fd:	89 f0                	mov    %esi,%eax
801011ff:	5b                   	pop    %ebx
80101200:	5e                   	pop    %esi
80101201:	5f                   	pop    %edi
80101202:	5d                   	pop    %ebp
80101203:	c3                   	ret    
80101204:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010120a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101210 <iget>:
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
80101210:	55                   	push   %ebp
80101211:	89 e5                	mov    %esp,%ebp
80101213:	57                   	push   %edi
80101214:	56                   	push   %esi
80101215:	53                   	push   %ebx
80101216:	89 c7                	mov    %eax,%edi
  struct inode *ip, *empty;

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
80101218:	31 f6                	xor    %esi,%esi
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010121a:	bb 74 0a 11 80       	mov    $0x80110a74,%ebx
// Find the inode with number inum on device dev
// and return the in-memory copy. Does not lock
// the inode and does not read it from disk.
static struct inode*
iget(uint dev, uint inum)
{
8010121f:	83 ec 28             	sub    $0x28,%esp
80101222:	89 55 e4             	mov    %edx,-0x1c(%ebp)
  struct inode *ip, *empty;

  acquire(&icache.lock);
80101225:	68 40 0a 11 80       	push   $0x80110a40
8010122a:	e8 21 31 00 00       	call   80104350 <acquire>
8010122f:	83 c4 10             	add    $0x10,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101232:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101235:	eb 1b                	jmp    80101252 <iget+0x42>
80101237:	89 f6                	mov    %esi,%esi
80101239:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101240:	85 f6                	test   %esi,%esi
80101242:	74 44                	je     80101288 <iget+0x78>

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
80101244:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010124a:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
80101250:	74 4e                	je     801012a0 <iget+0x90>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
80101252:	8b 4b 08             	mov    0x8(%ebx),%ecx
80101255:	85 c9                	test   %ecx,%ecx
80101257:	7e e7                	jle    80101240 <iget+0x30>
80101259:	39 3b                	cmp    %edi,(%ebx)
8010125b:	75 e3                	jne    80101240 <iget+0x30>
8010125d:	39 53 04             	cmp    %edx,0x4(%ebx)
80101260:	75 de                	jne    80101240 <iget+0x30>
      ip->ref++;
      release(&icache.lock);
80101262:	83 ec 0c             	sub    $0xc,%esp

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
80101265:	83 c1 01             	add    $0x1,%ecx
      release(&icache.lock);
      return ip;
80101268:	89 de                	mov    %ebx,%esi
  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
8010126a:	68 40 0a 11 80       	push   $0x80110a40

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
8010126f:	89 4b 08             	mov    %ecx,0x8(%ebx)
      release(&icache.lock);
80101272:	e8 89 31 00 00       	call   80104400 <release>
      return ip;
80101277:	83 c4 10             	add    $0x10,%esp
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);

  return ip;
}
8010127a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010127d:	89 f0                	mov    %esi,%eax
8010127f:	5b                   	pop    %ebx
80101280:	5e                   	pop    %esi
80101281:	5f                   	pop    %edi
80101282:	5d                   	pop    %ebp
80101283:	c3                   	ret    
80101284:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
      ip->ref++;
      release(&icache.lock);
      return ip;
    }
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
80101288:	85 c9                	test   %ecx,%ecx
8010128a:	0f 44 f3             	cmove  %ebx,%esi

  acquire(&icache.lock);

  // Is the inode already cached?
  empty = 0;
  for(ip = &icache.inode[0]; ip < &icache.inode[NINODE]; ip++){
8010128d:	81 c3 90 00 00 00    	add    $0x90,%ebx
80101293:	81 fb 94 26 11 80    	cmp    $0x80112694,%ebx
80101299:	75 b7                	jne    80101252 <iget+0x42>
8010129b:	90                   	nop
8010129c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
801012a0:	85 f6                	test   %esi,%esi
801012a2:	74 2d                	je     801012d1 <iget+0xc1>
  ip = empty;
  ip->dev = dev;
  ip->inum = inum;
  ip->ref = 1;
  ip->valid = 0;
  release(&icache.lock);
801012a4:	83 ec 0c             	sub    $0xc,%esp
  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");

  ip = empty;
  ip->dev = dev;
801012a7:	89 3e                	mov    %edi,(%esi)
  ip->inum = inum;
801012a9:	89 56 04             	mov    %edx,0x4(%esi)
  ip->ref = 1;
801012ac:	c7 46 08 01 00 00 00 	movl   $0x1,0x8(%esi)
  ip->valid = 0;
801012b3:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
  release(&icache.lock);
801012ba:	68 40 0a 11 80       	push   $0x80110a40
801012bf:	e8 3c 31 00 00       	call   80104400 <release>

  return ip;
801012c4:	83 c4 10             	add    $0x10,%esp
}
801012c7:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012ca:	89 f0                	mov    %esi,%eax
801012cc:	5b                   	pop    %ebx
801012cd:	5e                   	pop    %esi
801012ce:	5f                   	pop    %edi
801012cf:	5d                   	pop    %ebp
801012d0:	c3                   	ret    
      empty = ip;
  }

  // Recycle an inode cache entry.
  if(empty == 0)
    panic("iget: no inodes");
801012d1:	83 ec 0c             	sub    $0xc,%esp
801012d4:	68 35 71 10 80       	push   $0x80107135
801012d9:	e8 92 f0 ff ff       	call   80100370 <panic>
801012de:	66 90                	xchg   %ax,%ax

801012e0 <bmap>:

// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
static uint
bmap(struct inode *ip, uint bn)
{
801012e0:	55                   	push   %ebp
801012e1:	89 e5                	mov    %esp,%ebp
801012e3:	57                   	push   %edi
801012e4:	56                   	push   %esi
801012e5:	53                   	push   %ebx
801012e6:	89 c6                	mov    %eax,%esi
801012e8:	83 ec 1c             	sub    $0x1c,%esp
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
801012eb:	83 fa 0b             	cmp    $0xb,%edx
801012ee:	77 18                	ja     80101308 <bmap+0x28>
801012f0:	8d 1c 90             	lea    (%eax,%edx,4),%ebx
    if((addr = ip->addrs[bn]) == 0)
801012f3:	8b 43 5c             	mov    0x5c(%ebx),%eax
801012f6:	85 c0                	test   %eax,%eax
801012f8:	74 76                	je     80101370 <bmap+0x90>
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
801012fa:	8d 65 f4             	lea    -0xc(%ebp),%esp
801012fd:	5b                   	pop    %ebx
801012fe:	5e                   	pop    %esi
801012ff:	5f                   	pop    %edi
80101300:	5d                   	pop    %ebp
80101301:	c3                   	ret    
80101302:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
    return addr;
  }
  bn -= NDIRECT;
80101308:	8d 5a f4             	lea    -0xc(%edx),%ebx

  if(bn < NINDIRECT){
8010130b:	83 fb 7f             	cmp    $0x7f,%ebx
8010130e:	0f 87 83 00 00 00    	ja     80101397 <bmap+0xb7>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
80101314:	8b 80 8c 00 00 00    	mov    0x8c(%eax),%eax
8010131a:	85 c0                	test   %eax,%eax
8010131c:	74 6a                	je     80101388 <bmap+0xa8>
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
8010131e:	83 ec 08             	sub    $0x8,%esp
80101321:	50                   	push   %eax
80101322:	ff 36                	pushl  (%esi)
80101324:	e8 a7 ed ff ff       	call   801000d0 <bread>
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101329:	8d 54 98 5c          	lea    0x5c(%eax,%ebx,4),%edx
8010132d:	83 c4 10             	add    $0x10,%esp

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
80101330:	89 c7                	mov    %eax,%edi
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
80101332:	8b 1a                	mov    (%edx),%ebx
80101334:	85 db                	test   %ebx,%ebx
80101336:	75 1d                	jne    80101355 <bmap+0x75>
      a[bn] = addr = balloc(ip->dev);
80101338:	8b 06                	mov    (%esi),%eax
8010133a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010133d:	e8 be fd ff ff       	call   80101100 <balloc>
80101342:	8b 55 e4             	mov    -0x1c(%ebp),%edx
      log_write(bp);
80101345:	83 ec 0c             	sub    $0xc,%esp
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
    bp = bread(ip->dev, addr);
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
80101348:	89 c3                	mov    %eax,%ebx
8010134a:	89 02                	mov    %eax,(%edx)
      log_write(bp);
8010134c:	57                   	push   %edi
8010134d:	e8 de 19 00 00       	call   80102d30 <log_write>
80101352:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
80101355:	83 ec 0c             	sub    $0xc,%esp
80101358:	57                   	push   %edi
80101359:	e8 82 ee ff ff       	call   801001e0 <brelse>
8010135e:	83 c4 10             	add    $0x10,%esp
    return addr;
  }

  panic("bmap: out of range");
}
80101361:	8d 65 f4             	lea    -0xc(%ebp),%esp
    a = (uint*)bp->data;
    if((addr = a[bn]) == 0){
      a[bn] = addr = balloc(ip->dev);
      log_write(bp);
    }
    brelse(bp);
80101364:	89 d8                	mov    %ebx,%eax
    return addr;
  }

  panic("bmap: out of range");
}
80101366:	5b                   	pop    %ebx
80101367:	5e                   	pop    %esi
80101368:	5f                   	pop    %edi
80101369:	5d                   	pop    %ebp
8010136a:	c3                   	ret    
8010136b:	90                   	nop
8010136c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    if((addr = ip->addrs[bn]) == 0)
      ip->addrs[bn] = addr = balloc(ip->dev);
80101370:	8b 06                	mov    (%esi),%eax
80101372:	e8 89 fd ff ff       	call   80101100 <balloc>
80101377:	89 43 5c             	mov    %eax,0x5c(%ebx)
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
}
8010137a:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010137d:	5b                   	pop    %ebx
8010137e:	5e                   	pop    %esi
8010137f:	5f                   	pop    %edi
80101380:	5d                   	pop    %ebp
80101381:	c3                   	ret    
80101382:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  bn -= NDIRECT;

  if(bn < NINDIRECT){
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0)
      ip->addrs[NDIRECT] = addr = balloc(ip->dev);
80101388:	8b 06                	mov    (%esi),%eax
8010138a:	e8 71 fd ff ff       	call   80101100 <balloc>
8010138f:	89 86 8c 00 00 00    	mov    %eax,0x8c(%esi)
80101395:	eb 87                	jmp    8010131e <bmap+0x3e>
    }
    brelse(bp);
    return addr;
  }

  panic("bmap: out of range");
80101397:	83 ec 0c             	sub    $0xc,%esp
8010139a:	68 45 71 10 80       	push   $0x80107145
8010139f:	e8 cc ef ff ff       	call   80100370 <panic>
801013a4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801013aa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801013b0 <readsb>:
struct superblock sb; 

// Read the super block.
void
readsb(int dev, struct superblock *sb)
{
801013b0:	55                   	push   %ebp
801013b1:	89 e5                	mov    %esp,%ebp
801013b3:	56                   	push   %esi
801013b4:	53                   	push   %ebx
801013b5:	8b 75 0c             	mov    0xc(%ebp),%esi
  struct buf *bp;

  bp = bread(dev, 1);
801013b8:	83 ec 08             	sub    $0x8,%esp
801013bb:	6a 01                	push   $0x1
801013bd:	ff 75 08             	pushl  0x8(%ebp)
801013c0:	e8 0b ed ff ff       	call   801000d0 <bread>
801013c5:	89 c3                	mov    %eax,%ebx
  memmove(sb, bp->data, sizeof(*sb));
801013c7:	8d 40 5c             	lea    0x5c(%eax),%eax
801013ca:	83 c4 0c             	add    $0xc,%esp
801013cd:	6a 1c                	push   $0x1c
801013cf:	50                   	push   %eax
801013d0:	56                   	push   %esi
801013d1:	e8 2a 31 00 00       	call   80104500 <memmove>
  brelse(bp);
801013d6:	89 5d 08             	mov    %ebx,0x8(%ebp)
801013d9:	83 c4 10             	add    $0x10,%esp
}
801013dc:	8d 65 f8             	lea    -0x8(%ebp),%esp
801013df:	5b                   	pop    %ebx
801013e0:	5e                   	pop    %esi
801013e1:	5d                   	pop    %ebp
{
  struct buf *bp;

  bp = bread(dev, 1);
  memmove(sb, bp->data, sizeof(*sb));
  brelse(bp);
801013e2:	e9 f9 ed ff ff       	jmp    801001e0 <brelse>
801013e7:	89 f6                	mov    %esi,%esi
801013e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801013f0 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
801013f0:	55                   	push   %ebp
801013f1:	89 e5                	mov    %esp,%ebp
801013f3:	56                   	push   %esi
801013f4:	53                   	push   %ebx
801013f5:	89 d3                	mov    %edx,%ebx
801013f7:	89 c6                	mov    %eax,%esi
  struct buf *bp;
  int bi, m;

  readsb(dev, &sb);
801013f9:	83 ec 08             	sub    $0x8,%esp
801013fc:	68 20 0a 11 80       	push   $0x80110a20
80101401:	50                   	push   %eax
80101402:	e8 a9 ff ff ff       	call   801013b0 <readsb>
  bp = bread(dev, BBLOCK(b, sb));
80101407:	58                   	pop    %eax
80101408:	5a                   	pop    %edx
80101409:	89 da                	mov    %ebx,%edx
8010140b:	c1 ea 0c             	shr    $0xc,%edx
8010140e:	03 15 38 0a 11 80    	add    0x80110a38,%edx
80101414:	52                   	push   %edx
80101415:	56                   	push   %esi
80101416:	e8 b5 ec ff ff       	call   801000d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
8010141b:	89 d9                	mov    %ebx,%ecx
  if((bp->data[bi/8] & m) == 0)
8010141d:	81 e3 ff 0f 00 00    	and    $0xfff,%ebx
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101423:	ba 01 00 00 00       	mov    $0x1,%edx
80101428:	83 e1 07             	and    $0x7,%ecx
  if((bp->data[bi/8] & m) == 0)
8010142b:	c1 fb 03             	sar    $0x3,%ebx
8010142e:	83 c4 10             	add    $0x10,%esp
  int bi, m;

  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
80101431:	d3 e2                	shl    %cl,%edx
  if((bp->data[bi/8] & m) == 0)
80101433:	0f b6 4c 18 5c       	movzbl 0x5c(%eax,%ebx,1),%ecx
80101438:	85 d1                	test   %edx,%ecx
8010143a:	74 27                	je     80101463 <bfree+0x73>
8010143c:	89 c6                	mov    %eax,%esi
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
8010143e:	f7 d2                	not    %edx
80101440:	89 c8                	mov    %ecx,%eax
  log_write(bp);
80101442:	83 ec 0c             	sub    $0xc,%esp
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
80101445:	21 d0                	and    %edx,%eax
80101447:	88 44 1e 5c          	mov    %al,0x5c(%esi,%ebx,1)
  log_write(bp);
8010144b:	56                   	push   %esi
8010144c:	e8 df 18 00 00       	call   80102d30 <log_write>
  brelse(bp);
80101451:	89 34 24             	mov    %esi,(%esp)
80101454:	e8 87 ed ff ff       	call   801001e0 <brelse>
}
80101459:	83 c4 10             	add    $0x10,%esp
8010145c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010145f:	5b                   	pop    %ebx
80101460:	5e                   	pop    %esi
80101461:	5d                   	pop    %ebp
80101462:	c3                   	ret    
  readsb(dev, &sb);
  bp = bread(dev, BBLOCK(b, sb));
  bi = b % BPB;
  m = 1 << (bi % 8);
  if((bp->data[bi/8] & m) == 0)
    panic("freeing free block");
80101463:	83 ec 0c             	sub    $0xc,%esp
80101466:	68 58 71 10 80       	push   $0x80107158
8010146b:	e8 00 ef ff ff       	call   80100370 <panic>

80101470 <iinit>:
  struct inode inode[NINODE];
} icache;

void
iinit(int dev)
{
80101470:	55                   	push   %ebp
80101471:	89 e5                	mov    %esp,%ebp
80101473:	53                   	push   %ebx
80101474:	bb 80 0a 11 80       	mov    $0x80110a80,%ebx
80101479:	83 ec 0c             	sub    $0xc,%esp
  int i = 0;
  
  initlock(&icache.lock, "icache");
8010147c:	68 6b 71 10 80       	push   $0x8010716b
80101481:	68 40 0a 11 80       	push   $0x80110a40
80101486:	e8 65 2d 00 00       	call   801041f0 <initlock>
8010148b:	83 c4 10             	add    $0x10,%esp
8010148e:	66 90                	xchg   %ax,%ax
  for(i = 0; i < NINODE; i++) {
    initsleeplock(&icache.inode[i].lock, "inode");
80101490:	83 ec 08             	sub    $0x8,%esp
80101493:	68 72 71 10 80       	push   $0x80107172
80101498:	53                   	push   %ebx
80101499:	81 c3 90 00 00 00    	add    $0x90,%ebx
8010149f:	e8 1c 2c 00 00       	call   801040c0 <initsleeplock>
iinit(int dev)
{
  int i = 0;
  
  initlock(&icache.lock, "icache");
  for(i = 0; i < NINODE; i++) {
801014a4:	83 c4 10             	add    $0x10,%esp
801014a7:	81 fb a0 26 11 80    	cmp    $0x801126a0,%ebx
801014ad:	75 e1                	jne    80101490 <iinit+0x20>
    initsleeplock(&icache.inode[i].lock, "inode");
  }

  readsb(dev, &sb);
801014af:	83 ec 08             	sub    $0x8,%esp
801014b2:	68 20 0a 11 80       	push   $0x80110a20
801014b7:	ff 75 08             	pushl  0x8(%ebp)
801014ba:	e8 f1 fe ff ff       	call   801013b0 <readsb>
  cprintf("sb: size %d nblocks %d ninodes %d nlog %d logstart %d\
801014bf:	ff 35 38 0a 11 80    	pushl  0x80110a38
801014c5:	ff 35 34 0a 11 80    	pushl  0x80110a34
801014cb:	ff 35 30 0a 11 80    	pushl  0x80110a30
801014d1:	ff 35 2c 0a 11 80    	pushl  0x80110a2c
801014d7:	ff 35 28 0a 11 80    	pushl  0x80110a28
801014dd:	ff 35 24 0a 11 80    	pushl  0x80110a24
801014e3:	ff 35 20 0a 11 80    	pushl  0x80110a20
801014e9:	68 d8 71 10 80       	push   $0x801071d8
801014ee:	e8 6d f1 ff ff       	call   80100660 <cprintf>
 inodestart %d bmap start %d\n", sb.size, sb.nblocks,
          sb.ninodes, sb.nlog, sb.logstart, sb.inodestart,
          sb.bmapstart);
}
801014f3:	83 c4 30             	add    $0x30,%esp
801014f6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801014f9:	c9                   	leave  
801014fa:	c3                   	ret    
801014fb:	90                   	nop
801014fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101500 <ialloc>:
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101500:	55                   	push   %ebp
80101501:	89 e5                	mov    %esp,%ebp
80101503:	57                   	push   %edi
80101504:	56                   	push   %esi
80101505:	53                   	push   %ebx
80101506:	83 ec 1c             	sub    $0x1c,%esp
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101509:	83 3d 28 0a 11 80 01 	cmpl   $0x1,0x80110a28
// Allocate an inode on device dev.
// Mark it as allocated by  giving it type type.
// Returns an unlocked but allocated and referenced inode.
struct inode*
ialloc(uint dev, short type)
{
80101510:	8b 45 0c             	mov    0xc(%ebp),%eax
80101513:	8b 75 08             	mov    0x8(%ebp),%esi
80101516:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101519:	0f 86 91 00 00 00    	jbe    801015b0 <ialloc+0xb0>
8010151f:	bb 01 00 00 00       	mov    $0x1,%ebx
80101524:	eb 21                	jmp    80101547 <ialloc+0x47>
80101526:	8d 76 00             	lea    0x0(%esi),%esi
80101529:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101530:	83 ec 0c             	sub    $0xc,%esp
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
80101533:	83 c3 01             	add    $0x1,%ebx
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
    }
    brelse(bp);
80101536:	57                   	push   %edi
80101537:	e8 a4 ec ff ff       	call   801001e0 <brelse>
{
  int inum;
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
8010153c:	83 c4 10             	add    $0x10,%esp
8010153f:	39 1d 28 0a 11 80    	cmp    %ebx,0x80110a28
80101545:	76 69                	jbe    801015b0 <ialloc+0xb0>
    bp = bread(dev, IBLOCK(inum, sb));
80101547:	89 d8                	mov    %ebx,%eax
80101549:	83 ec 08             	sub    $0x8,%esp
8010154c:	c1 e8 03             	shr    $0x3,%eax
8010154f:	03 05 34 0a 11 80    	add    0x80110a34,%eax
80101555:	50                   	push   %eax
80101556:	56                   	push   %esi
80101557:	e8 74 eb ff ff       	call   801000d0 <bread>
8010155c:	89 c7                	mov    %eax,%edi
    dip = (struct dinode*)bp->data + inum%IPB;
8010155e:	89 d8                	mov    %ebx,%eax
    if(dip->type == 0){  // a free inode
80101560:	83 c4 10             	add    $0x10,%esp
  struct buf *bp;
  struct dinode *dip;

  for(inum = 1; inum < sb.ninodes; inum++){
    bp = bread(dev, IBLOCK(inum, sb));
    dip = (struct dinode*)bp->data + inum%IPB;
80101563:	83 e0 07             	and    $0x7,%eax
80101566:	c1 e0 06             	shl    $0x6,%eax
80101569:	8d 4c 07 5c          	lea    0x5c(%edi,%eax,1),%ecx
    if(dip->type == 0){  // a free inode
8010156d:	66 83 39 00          	cmpw   $0x0,(%ecx)
80101571:	75 bd                	jne    80101530 <ialloc+0x30>
      memset(dip, 0, sizeof(*dip));
80101573:	83 ec 04             	sub    $0x4,%esp
80101576:	89 4d e0             	mov    %ecx,-0x20(%ebp)
80101579:	6a 40                	push   $0x40
8010157b:	6a 00                	push   $0x0
8010157d:	51                   	push   %ecx
8010157e:	e8 cd 2e 00 00       	call   80104450 <memset>
      dip->type = type;
80101583:	0f b7 45 e4          	movzwl -0x1c(%ebp),%eax
80101587:	8b 4d e0             	mov    -0x20(%ebp),%ecx
8010158a:	66 89 01             	mov    %ax,(%ecx)
      log_write(bp);   // mark it allocated on the disk
8010158d:	89 3c 24             	mov    %edi,(%esp)
80101590:	e8 9b 17 00 00       	call   80102d30 <log_write>
      brelse(bp);
80101595:	89 3c 24             	mov    %edi,(%esp)
80101598:	e8 43 ec ff ff       	call   801001e0 <brelse>
      return iget(dev, inum);
8010159d:	83 c4 10             	add    $0x10,%esp
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015a3:	89 da                	mov    %ebx,%edx
801015a5:	89 f0                	mov    %esi,%eax
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
}
801015a7:	5b                   	pop    %ebx
801015a8:	5e                   	pop    %esi
801015a9:	5f                   	pop    %edi
801015aa:	5d                   	pop    %ebp
    if(dip->type == 0){  // a free inode
      memset(dip, 0, sizeof(*dip));
      dip->type = type;
      log_write(bp);   // mark it allocated on the disk
      brelse(bp);
      return iget(dev, inum);
801015ab:	e9 60 fc ff ff       	jmp    80101210 <iget>
    }
    brelse(bp);
  }
  panic("ialloc: no inodes");
801015b0:	83 ec 0c             	sub    $0xc,%esp
801015b3:	68 78 71 10 80       	push   $0x80107178
801015b8:	e8 b3 ed ff ff       	call   80100370 <panic>
801015bd:	8d 76 00             	lea    0x0(%esi),%esi

801015c0 <iupdate>:
// Must be called after every change to an ip->xxx field
// that lives on disk, since i-node cache is write-through.
// Caller must hold ip->lock.
void
iupdate(struct inode *ip)
{
801015c0:	55                   	push   %ebp
801015c1:	89 e5                	mov    %esp,%ebp
801015c3:	56                   	push   %esi
801015c4:	53                   	push   %ebx
801015c5:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015c8:	83 ec 08             	sub    $0x8,%esp
801015cb:	8b 43 04             	mov    0x4(%ebx),%eax
  dip->type = ip->type;
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ce:	83 c3 5c             	add    $0x5c,%ebx
iupdate(struct inode *ip)
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801015d1:	c1 e8 03             	shr    $0x3,%eax
801015d4:	03 05 34 0a 11 80    	add    0x80110a34,%eax
801015da:	50                   	push   %eax
801015db:	ff 73 a4             	pushl  -0x5c(%ebx)
801015de:	e8 ed ea ff ff       	call   801000d0 <bread>
801015e3:	89 c6                	mov    %eax,%esi
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015e5:	8b 43 a8             	mov    -0x58(%ebx),%eax
  dip->type = ip->type;
801015e8:	0f b7 53 f4          	movzwl -0xc(%ebx),%edx
  dip->major = ip->major;
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
801015ec:	83 c4 0c             	add    $0xc,%esp
{
  struct buf *bp;
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
801015ef:	83 e0 07             	and    $0x7,%eax
801015f2:	c1 e0 06             	shl    $0x6,%eax
801015f5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
  dip->type = ip->type;
801015f9:	66 89 10             	mov    %dx,(%eax)
  dip->major = ip->major;
801015fc:	0f b7 53 f6          	movzwl -0xa(%ebx),%edx
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
80101600:	83 c0 0c             	add    $0xc,%eax
  struct dinode *dip;

  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
  dip = (struct dinode*)bp->data + ip->inum%IPB;
  dip->type = ip->type;
  dip->major = ip->major;
80101603:	66 89 50 f6          	mov    %dx,-0xa(%eax)
  dip->minor = ip->minor;
80101607:	0f b7 53 f8          	movzwl -0x8(%ebx),%edx
8010160b:	66 89 50 f8          	mov    %dx,-0x8(%eax)
  dip->nlink = ip->nlink;
8010160f:	0f b7 53 fa          	movzwl -0x6(%ebx),%edx
80101613:	66 89 50 fa          	mov    %dx,-0x6(%eax)
  dip->size = ip->size;
80101617:	8b 53 fc             	mov    -0x4(%ebx),%edx
8010161a:	89 50 fc             	mov    %edx,-0x4(%eax)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
8010161d:	6a 34                	push   $0x34
8010161f:	53                   	push   %ebx
80101620:	50                   	push   %eax
80101621:	e8 da 2e 00 00       	call   80104500 <memmove>
  log_write(bp);
80101626:	89 34 24             	mov    %esi,(%esp)
80101629:	e8 02 17 00 00       	call   80102d30 <log_write>
  brelse(bp);
8010162e:	89 75 08             	mov    %esi,0x8(%ebp)
80101631:	83 c4 10             	add    $0x10,%esp
}
80101634:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101637:	5b                   	pop    %ebx
80101638:	5e                   	pop    %esi
80101639:	5d                   	pop    %ebp
  dip->minor = ip->minor;
  dip->nlink = ip->nlink;
  dip->size = ip->size;
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
  log_write(bp);
  brelse(bp);
8010163a:	e9 a1 eb ff ff       	jmp    801001e0 <brelse>
8010163f:	90                   	nop

80101640 <idup>:

// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
80101640:	55                   	push   %ebp
80101641:	89 e5                	mov    %esp,%ebp
80101643:	53                   	push   %ebx
80101644:	83 ec 10             	sub    $0x10,%esp
80101647:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&icache.lock);
8010164a:	68 40 0a 11 80       	push   $0x80110a40
8010164f:	e8 fc 2c 00 00       	call   80104350 <acquire>
  ip->ref++;
80101654:	83 43 08 01          	addl   $0x1,0x8(%ebx)
  release(&icache.lock);
80101658:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
8010165f:	e8 9c 2d 00 00       	call   80104400 <release>
  return ip;
}
80101664:	89 d8                	mov    %ebx,%eax
80101666:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101669:	c9                   	leave  
8010166a:	c3                   	ret    
8010166b:	90                   	nop
8010166c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101670 <ilock>:

// Lock the given inode.
// Reads the inode from disk if necessary.
void
ilock(struct inode *ip)
{
80101670:	55                   	push   %ebp
80101671:	89 e5                	mov    %esp,%ebp
80101673:	56                   	push   %esi
80101674:	53                   	push   %ebx
80101675:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
80101678:	85 db                	test   %ebx,%ebx
8010167a:	0f 84 b7 00 00 00    	je     80101737 <ilock+0xc7>
80101680:	8b 53 08             	mov    0x8(%ebx),%edx
80101683:	85 d2                	test   %edx,%edx
80101685:	0f 8e ac 00 00 00    	jle    80101737 <ilock+0xc7>
    panic("ilock");

  acquiresleep(&ip->lock);
8010168b:	8d 43 0c             	lea    0xc(%ebx),%eax
8010168e:	83 ec 0c             	sub    $0xc,%esp
80101691:	50                   	push   %eax
80101692:	e8 69 2a 00 00       	call   80104100 <acquiresleep>

  if(ip->valid == 0){
80101697:	8b 43 4c             	mov    0x4c(%ebx),%eax
8010169a:	83 c4 10             	add    $0x10,%esp
8010169d:	85 c0                	test   %eax,%eax
8010169f:	74 0f                	je     801016b0 <ilock+0x40>
    brelse(bp);
    ip->valid = 1;
    if(ip->type == 0)
      panic("ilock: no type");
  }
}
801016a1:	8d 65 f8             	lea    -0x8(%ebp),%esp
801016a4:	5b                   	pop    %ebx
801016a5:	5e                   	pop    %esi
801016a6:	5d                   	pop    %ebp
801016a7:	c3                   	ret    
801016a8:	90                   	nop
801016a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    panic("ilock");

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
801016b0:	8b 43 04             	mov    0x4(%ebx),%eax
801016b3:	83 ec 08             	sub    $0x8,%esp
801016b6:	c1 e8 03             	shr    $0x3,%eax
801016b9:	03 05 34 0a 11 80    	add    0x80110a34,%eax
801016bf:	50                   	push   %eax
801016c0:	ff 33                	pushl  (%ebx)
801016c2:	e8 09 ea ff ff       	call   801000d0 <bread>
801016c7:	89 c6                	mov    %eax,%esi
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016c9:	8b 43 04             	mov    0x4(%ebx),%eax
    ip->type = dip->type;
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016cc:	83 c4 0c             	add    $0xc,%esp

  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
801016cf:	83 e0 07             	and    $0x7,%eax
801016d2:	c1 e0 06             	shl    $0x6,%eax
801016d5:	8d 44 06 5c          	lea    0x5c(%esi,%eax,1),%eax
    ip->type = dip->type;
801016d9:	0f b7 10             	movzwl (%eax),%edx
    ip->major = dip->major;
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
801016dc:	83 c0 0c             	add    $0xc,%eax
  acquiresleep(&ip->lock);

  if(ip->valid == 0){
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    ip->type = dip->type;
801016df:	66 89 53 50          	mov    %dx,0x50(%ebx)
    ip->major = dip->major;
801016e3:	0f b7 50 f6          	movzwl -0xa(%eax),%edx
801016e7:	66 89 53 52          	mov    %dx,0x52(%ebx)
    ip->minor = dip->minor;
801016eb:	0f b7 50 f8          	movzwl -0x8(%eax),%edx
801016ef:	66 89 53 54          	mov    %dx,0x54(%ebx)
    ip->nlink = dip->nlink;
801016f3:	0f b7 50 fa          	movzwl -0x6(%eax),%edx
801016f7:	66 89 53 56          	mov    %dx,0x56(%ebx)
    ip->size = dip->size;
801016fb:	8b 50 fc             	mov    -0x4(%eax),%edx
801016fe:	89 53 58             	mov    %edx,0x58(%ebx)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
80101701:	6a 34                	push   $0x34
80101703:	50                   	push   %eax
80101704:	8d 43 5c             	lea    0x5c(%ebx),%eax
80101707:	50                   	push   %eax
80101708:	e8 f3 2d 00 00       	call   80104500 <memmove>
    brelse(bp);
8010170d:	89 34 24             	mov    %esi,(%esp)
80101710:	e8 cb ea ff ff       	call   801001e0 <brelse>
    ip->valid = 1;
    if(ip->type == 0)
80101715:	83 c4 10             	add    $0x10,%esp
80101718:	66 83 7b 50 00       	cmpw   $0x0,0x50(%ebx)
    ip->minor = dip->minor;
    ip->nlink = dip->nlink;
    ip->size = dip->size;
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    brelse(bp);
    ip->valid = 1;
8010171d:	c7 43 4c 01 00 00 00 	movl   $0x1,0x4c(%ebx)
    if(ip->type == 0)
80101724:	0f 85 77 ff ff ff    	jne    801016a1 <ilock+0x31>
      panic("ilock: no type");
8010172a:	83 ec 0c             	sub    $0xc,%esp
8010172d:	68 90 71 10 80       	push   $0x80107190
80101732:	e8 39 ec ff ff       	call   80100370 <panic>
{
  struct buf *bp;
  struct dinode *dip;

  if(ip == 0 || ip->ref < 1)
    panic("ilock");
80101737:	83 ec 0c             	sub    $0xc,%esp
8010173a:	68 8a 71 10 80       	push   $0x8010718a
8010173f:	e8 2c ec ff ff       	call   80100370 <panic>
80101744:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010174a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101750 <iunlock>:
}

// Unlock the given inode.
void
iunlock(struct inode *ip)
{
80101750:	55                   	push   %ebp
80101751:	89 e5                	mov    %esp,%ebp
80101753:	56                   	push   %esi
80101754:	53                   	push   %ebx
80101755:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
80101758:	85 db                	test   %ebx,%ebx
8010175a:	74 28                	je     80101784 <iunlock+0x34>
8010175c:	8d 73 0c             	lea    0xc(%ebx),%esi
8010175f:	83 ec 0c             	sub    $0xc,%esp
80101762:	56                   	push   %esi
80101763:	e8 38 2a 00 00       	call   801041a0 <holdingsleep>
80101768:	83 c4 10             	add    $0x10,%esp
8010176b:	85 c0                	test   %eax,%eax
8010176d:	74 15                	je     80101784 <iunlock+0x34>
8010176f:	8b 43 08             	mov    0x8(%ebx),%eax
80101772:	85 c0                	test   %eax,%eax
80101774:	7e 0e                	jle    80101784 <iunlock+0x34>
    panic("iunlock");

  releasesleep(&ip->lock);
80101776:	89 75 08             	mov    %esi,0x8(%ebp)
}
80101779:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010177c:	5b                   	pop    %ebx
8010177d:	5e                   	pop    %esi
8010177e:	5d                   	pop    %ebp
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");

  releasesleep(&ip->lock);
8010177f:	e9 dc 29 00 00       	jmp    80104160 <releasesleep>
// Unlock the given inode.
void
iunlock(struct inode *ip)
{
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    panic("iunlock");
80101784:	83 ec 0c             	sub    $0xc,%esp
80101787:	68 9f 71 10 80       	push   $0x8010719f
8010178c:	e8 df eb ff ff       	call   80100370 <panic>
80101791:	eb 0d                	jmp    801017a0 <iput>
80101793:	90                   	nop
80101794:	90                   	nop
80101795:	90                   	nop
80101796:	90                   	nop
80101797:	90                   	nop
80101798:	90                   	nop
80101799:	90                   	nop
8010179a:	90                   	nop
8010179b:	90                   	nop
8010179c:	90                   	nop
8010179d:	90                   	nop
8010179e:	90                   	nop
8010179f:	90                   	nop

801017a0 <iput>:
// to it, free the inode (and its content) on disk.
// All calls to iput() must be inside a transaction in
// case it has to free the inode.
void
iput(struct inode *ip)
{
801017a0:	55                   	push   %ebp
801017a1:	89 e5                	mov    %esp,%ebp
801017a3:	57                   	push   %edi
801017a4:	56                   	push   %esi
801017a5:	53                   	push   %ebx
801017a6:	83 ec 28             	sub    $0x28,%esp
801017a9:	8b 75 08             	mov    0x8(%ebp),%esi
  acquiresleep(&ip->lock);
801017ac:	8d 7e 0c             	lea    0xc(%esi),%edi
801017af:	57                   	push   %edi
801017b0:	e8 4b 29 00 00       	call   80104100 <acquiresleep>
  if(ip->valid && ip->nlink == 0){
801017b5:	8b 56 4c             	mov    0x4c(%esi),%edx
801017b8:	83 c4 10             	add    $0x10,%esp
801017bb:	85 d2                	test   %edx,%edx
801017bd:	74 07                	je     801017c6 <iput+0x26>
801017bf:	66 83 7e 56 00       	cmpw   $0x0,0x56(%esi)
801017c4:	74 32                	je     801017f8 <iput+0x58>
      ip->type = 0;
      iupdate(ip);
      ip->valid = 0;
    }
  }
  releasesleep(&ip->lock);
801017c6:	83 ec 0c             	sub    $0xc,%esp
801017c9:	57                   	push   %edi
801017ca:	e8 91 29 00 00       	call   80104160 <releasesleep>

  acquire(&icache.lock);
801017cf:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
801017d6:	e8 75 2b 00 00       	call   80104350 <acquire>
  ip->ref--;
801017db:	83 6e 08 01          	subl   $0x1,0x8(%esi)
  release(&icache.lock);
801017df:	83 c4 10             	add    $0x10,%esp
801017e2:	c7 45 08 40 0a 11 80 	movl   $0x80110a40,0x8(%ebp)
}
801017e9:	8d 65 f4             	lea    -0xc(%ebp),%esp
801017ec:	5b                   	pop    %ebx
801017ed:	5e                   	pop    %esi
801017ee:	5f                   	pop    %edi
801017ef:	5d                   	pop    %ebp
  }
  releasesleep(&ip->lock);

  acquire(&icache.lock);
  ip->ref--;
  release(&icache.lock);
801017f0:	e9 0b 2c 00 00       	jmp    80104400 <release>
801017f5:	8d 76 00             	lea    0x0(%esi),%esi
void
iput(struct inode *ip)
{
  acquiresleep(&ip->lock);
  if(ip->valid && ip->nlink == 0){
    acquire(&icache.lock);
801017f8:	83 ec 0c             	sub    $0xc,%esp
801017fb:	68 40 0a 11 80       	push   $0x80110a40
80101800:	e8 4b 2b 00 00       	call   80104350 <acquire>
    int r = ip->ref;
80101805:	8b 5e 08             	mov    0x8(%esi),%ebx
    release(&icache.lock);
80101808:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
8010180f:	e8 ec 2b 00 00       	call   80104400 <release>
    if(r == 1){
80101814:	83 c4 10             	add    $0x10,%esp
80101817:	83 fb 01             	cmp    $0x1,%ebx
8010181a:	75 aa                	jne    801017c6 <iput+0x26>
8010181c:	8d 8e 8c 00 00 00    	lea    0x8c(%esi),%ecx
80101822:	89 7d e4             	mov    %edi,-0x1c(%ebp)
80101825:	8d 5e 5c             	lea    0x5c(%esi),%ebx
80101828:	89 cf                	mov    %ecx,%edi
8010182a:	eb 0b                	jmp    80101837 <iput+0x97>
8010182c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101830:	83 c3 04             	add    $0x4,%ebx
{
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
80101833:	39 fb                	cmp    %edi,%ebx
80101835:	74 19                	je     80101850 <iput+0xb0>
    if(ip->addrs[i]){
80101837:	8b 13                	mov    (%ebx),%edx
80101839:	85 d2                	test   %edx,%edx
8010183b:	74 f3                	je     80101830 <iput+0x90>
      bfree(ip->dev, ip->addrs[i]);
8010183d:	8b 06                	mov    (%esi),%eax
8010183f:	e8 ac fb ff ff       	call   801013f0 <bfree>
      ip->addrs[i] = 0;
80101844:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
8010184a:	eb e4                	jmp    80101830 <iput+0x90>
8010184c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    }
  }

  if(ip->addrs[NDIRECT]){
80101850:	8b 86 8c 00 00 00    	mov    0x8c(%esi),%eax
80101856:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80101859:	85 c0                	test   %eax,%eax
8010185b:	75 33                	jne    80101890 <iput+0xf0>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
  iupdate(ip);
8010185d:	83 ec 0c             	sub    $0xc,%esp
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
80101860:	c7 46 58 00 00 00 00 	movl   $0x0,0x58(%esi)
  iupdate(ip);
80101867:	56                   	push   %esi
80101868:	e8 53 fd ff ff       	call   801015c0 <iupdate>
    int r = ip->ref;
    release(&icache.lock);
    if(r == 1){
      // inode has no links and no other references: truncate and free.
      itrunc(ip);
      ip->type = 0;
8010186d:	31 c0                	xor    %eax,%eax
8010186f:	66 89 46 50          	mov    %ax,0x50(%esi)
      iupdate(ip);
80101873:	89 34 24             	mov    %esi,(%esp)
80101876:	e8 45 fd ff ff       	call   801015c0 <iupdate>
      ip->valid = 0;
8010187b:	c7 46 4c 00 00 00 00 	movl   $0x0,0x4c(%esi)
80101882:	83 c4 10             	add    $0x10,%esp
80101885:	e9 3c ff ff ff       	jmp    801017c6 <iput+0x26>
8010188a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      ip->addrs[i] = 0;
    }
  }

  if(ip->addrs[NDIRECT]){
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
80101890:	83 ec 08             	sub    $0x8,%esp
80101893:	50                   	push   %eax
80101894:	ff 36                	pushl  (%esi)
80101896:	e8 35 e8 ff ff       	call   801000d0 <bread>
8010189b:	8d 88 5c 02 00 00    	lea    0x25c(%eax),%ecx
801018a1:	89 7d e0             	mov    %edi,-0x20(%ebp)
801018a4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    a = (uint*)bp->data;
801018a7:	8d 58 5c             	lea    0x5c(%eax),%ebx
801018aa:	83 c4 10             	add    $0x10,%esp
801018ad:	89 cf                	mov    %ecx,%edi
801018af:	eb 0e                	jmp    801018bf <iput+0x11f>
801018b1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801018b8:	83 c3 04             	add    $0x4,%ebx
    for(j = 0; j < NINDIRECT; j++){
801018bb:	39 fb                	cmp    %edi,%ebx
801018bd:	74 0f                	je     801018ce <iput+0x12e>
      if(a[j])
801018bf:	8b 13                	mov    (%ebx),%edx
801018c1:	85 d2                	test   %edx,%edx
801018c3:	74 f3                	je     801018b8 <iput+0x118>
        bfree(ip->dev, a[j]);
801018c5:	8b 06                	mov    (%esi),%eax
801018c7:	e8 24 fb ff ff       	call   801013f0 <bfree>
801018cc:	eb ea                	jmp    801018b8 <iput+0x118>
    }
    brelse(bp);
801018ce:	83 ec 0c             	sub    $0xc,%esp
801018d1:	ff 75 e4             	pushl  -0x1c(%ebp)
801018d4:	8b 7d e0             	mov    -0x20(%ebp),%edi
801018d7:	e8 04 e9 ff ff       	call   801001e0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
801018dc:	8b 96 8c 00 00 00    	mov    0x8c(%esi),%edx
801018e2:	8b 06                	mov    (%esi),%eax
801018e4:	e8 07 fb ff ff       	call   801013f0 <bfree>
    ip->addrs[NDIRECT] = 0;
801018e9:	c7 86 8c 00 00 00 00 	movl   $0x0,0x8c(%esi)
801018f0:	00 00 00 
801018f3:	83 c4 10             	add    $0x10,%esp
801018f6:	e9 62 ff ff ff       	jmp    8010185d <iput+0xbd>
801018fb:	90                   	nop
801018fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101900 <iunlockput>:
}

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
80101900:	55                   	push   %ebp
80101901:	89 e5                	mov    %esp,%ebp
80101903:	53                   	push   %ebx
80101904:	83 ec 10             	sub    $0x10,%esp
80101907:	8b 5d 08             	mov    0x8(%ebp),%ebx
  iunlock(ip);
8010190a:	53                   	push   %ebx
8010190b:	e8 40 fe ff ff       	call   80101750 <iunlock>
  iput(ip);
80101910:	89 5d 08             	mov    %ebx,0x8(%ebp)
80101913:	83 c4 10             	add    $0x10,%esp
}
80101916:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80101919:	c9                   	leave  
// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
  iput(ip);
8010191a:	e9 81 fe ff ff       	jmp    801017a0 <iput>
8010191f:	90                   	nop

80101920 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
80101920:	55                   	push   %ebp
80101921:	89 e5                	mov    %esp,%ebp
80101923:	8b 55 08             	mov    0x8(%ebp),%edx
80101926:	8b 45 0c             	mov    0xc(%ebp),%eax
  st->dev = ip->dev;
80101929:	8b 0a                	mov    (%edx),%ecx
8010192b:	89 48 04             	mov    %ecx,0x4(%eax)
  st->ino = ip->inum;
8010192e:	8b 4a 04             	mov    0x4(%edx),%ecx
80101931:	89 48 08             	mov    %ecx,0x8(%eax)
  st->type = ip->type;
80101934:	0f b7 4a 50          	movzwl 0x50(%edx),%ecx
80101938:	66 89 08             	mov    %cx,(%eax)
  st->nlink = ip->nlink;
8010193b:	0f b7 4a 56          	movzwl 0x56(%edx),%ecx
8010193f:	66 89 48 0c          	mov    %cx,0xc(%eax)
  st->size = ip->size;
80101943:	8b 52 58             	mov    0x58(%edx),%edx
80101946:	89 50 10             	mov    %edx,0x10(%eax)
}
80101949:	5d                   	pop    %ebp
8010194a:	c3                   	ret    
8010194b:	90                   	nop
8010194c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80101950 <readi>:
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101950:	55                   	push   %ebp
80101951:	89 e5                	mov    %esp,%ebp
80101953:	57                   	push   %edi
80101954:	56                   	push   %esi
80101955:	53                   	push   %ebx
80101956:	83 ec 1c             	sub    $0x1c,%esp
80101959:	8b 45 08             	mov    0x8(%ebp),%eax
8010195c:	8b 7d 0c             	mov    0xc(%ebp),%edi
8010195f:	8b 75 10             	mov    0x10(%ebp),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101962:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
//PAGEBREAK!
// Read data from inode.
// Caller must hold ip->lock.
int
readi(struct inode *ip, char *dst, uint off, uint n)
{
80101967:	89 7d e0             	mov    %edi,-0x20(%ebp)
8010196a:	8b 7d 14             	mov    0x14(%ebp),%edi
8010196d:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101970:	89 7d e4             	mov    %edi,-0x1c(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101973:	0f 84 a7 00 00 00    	je     80101a20 <readi+0xd0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
  }

  if(off > ip->size || off + n < off)
80101979:	8b 45 d8             	mov    -0x28(%ebp),%eax
8010197c:	8b 40 58             	mov    0x58(%eax),%eax
8010197f:	39 f0                	cmp    %esi,%eax
80101981:	0f 82 c1 00 00 00    	jb     80101a48 <readi+0xf8>
80101987:	8b 7d e4             	mov    -0x1c(%ebp),%edi
8010198a:	89 fa                	mov    %edi,%edx
8010198c:	01 f2                	add    %esi,%edx
8010198e:	0f 82 b4 00 00 00    	jb     80101a48 <readi+0xf8>
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
80101994:	89 c1                	mov    %eax,%ecx
80101996:	29 f1                	sub    %esi,%ecx
80101998:	39 d0                	cmp    %edx,%eax
8010199a:	0f 43 cf             	cmovae %edi,%ecx

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
8010199d:	31 ff                	xor    %edi,%edi
8010199f:	85 c9                	test   %ecx,%ecx
  }

  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;
801019a1:	89 4d e4             	mov    %ecx,-0x1c(%ebp)

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019a4:	74 6d                	je     80101a13 <readi+0xc3>
801019a6:	8d 76 00             	lea    0x0(%esi),%esi
801019a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019b0:	8b 5d d8             	mov    -0x28(%ebp),%ebx
801019b3:	89 f2                	mov    %esi,%edx
801019b5:	c1 ea 09             	shr    $0x9,%edx
801019b8:	89 d8                	mov    %ebx,%eax
801019ba:	e8 21 f9 ff ff       	call   801012e0 <bmap>
801019bf:	83 ec 08             	sub    $0x8,%esp
801019c2:	50                   	push   %eax
801019c3:	ff 33                	pushl  (%ebx)
    m = min(n - tot, BSIZE - off%BSIZE);
801019c5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
801019ca:	e8 01 e7 ff ff       	call   801000d0 <bread>
801019cf:	89 c2                	mov    %eax,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
801019d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801019d4:	89 f1                	mov    %esi,%ecx
801019d6:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
801019dc:	83 c4 0c             	add    $0xc,%esp
    memmove(dst, bp->data + off%BSIZE, m);
801019df:	89 55 dc             	mov    %edx,-0x24(%ebp)
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
801019e2:	29 cb                	sub    %ecx,%ebx
801019e4:	29 f8                	sub    %edi,%eax
801019e6:	39 c3                	cmp    %eax,%ebx
801019e8:	0f 47 d8             	cmova  %eax,%ebx
    memmove(dst, bp->data + off%BSIZE, m);
801019eb:	8d 44 0a 5c          	lea    0x5c(%edx,%ecx,1),%eax
801019ef:	53                   	push   %ebx
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
801019f0:	01 df                	add    %ebx,%edi
801019f2:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
801019f4:	50                   	push   %eax
801019f5:	ff 75 e0             	pushl  -0x20(%ebp)
801019f8:	e8 03 2b 00 00       	call   80104500 <memmove>
    brelse(bp);
801019fd:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101a00:	89 14 24             	mov    %edx,(%esp)
80101a03:	e8 d8 e7 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > ip->size)
    n = ip->size - off;

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
80101a08:	01 5d e0             	add    %ebx,-0x20(%ebp)
80101a0b:	83 c4 10             	add    $0x10,%esp
80101a0e:	39 7d e4             	cmp    %edi,-0x1c(%ebp)
80101a11:	77 9d                	ja     801019b0 <readi+0x60>
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
80101a13:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
80101a16:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a19:	5b                   	pop    %ebx
80101a1a:	5e                   	pop    %esi
80101a1b:	5f                   	pop    %edi
80101a1c:	5d                   	pop    %ebp
80101a1d:	c3                   	ret    
80101a1e:	66 90                	xchg   %ax,%ax
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
80101a20:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101a24:	66 83 f8 09          	cmp    $0x9,%ax
80101a28:	77 1e                	ja     80101a48 <readi+0xf8>
80101a2a:	8b 04 c5 c0 09 11 80 	mov    -0x7feef640(,%eax,8),%eax
80101a31:	85 c0                	test   %eax,%eax
80101a33:	74 13                	je     80101a48 <readi+0xf8>
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a35:	89 7d 10             	mov    %edi,0x10(%ebp)
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(dst, bp->data + off%BSIZE, m);
    brelse(bp);
  }
  return n;
}
80101a38:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101a3b:	5b                   	pop    %ebx
80101a3c:	5e                   	pop    %esi
80101a3d:	5f                   	pop    %edi
80101a3e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
    return devsw[ip->major].read(ip, dst, n);
80101a3f:	ff e0                	jmp    *%eax
80101a41:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].read)
      return -1;
80101a48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101a4d:	eb c7                	jmp    80101a16 <readi+0xc6>
80101a4f:	90                   	nop

80101a50 <writei>:
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a50:	55                   	push   %ebp
80101a51:	89 e5                	mov    %esp,%ebp
80101a53:	57                   	push   %edi
80101a54:	56                   	push   %esi
80101a55:	53                   	push   %ebx
80101a56:	83 ec 1c             	sub    $0x1c,%esp
80101a59:	8b 45 08             	mov    0x8(%ebp),%eax
80101a5c:	8b 75 0c             	mov    0xc(%ebp),%esi
80101a5f:	8b 7d 14             	mov    0x14(%ebp),%edi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a62:	66 83 78 50 03       	cmpw   $0x3,0x50(%eax)
// PAGEBREAK!
// Write data to inode.
// Caller must hold ip->lock.
int
writei(struct inode *ip, char *src, uint off, uint n)
{
80101a67:	89 75 dc             	mov    %esi,-0x24(%ebp)
80101a6a:	89 45 d8             	mov    %eax,-0x28(%ebp)
80101a6d:	8b 75 10             	mov    0x10(%ebp),%esi
80101a70:	89 7d e0             	mov    %edi,-0x20(%ebp)
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
80101a73:	0f 84 b7 00 00 00    	je     80101b30 <writei+0xe0>
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
  }

  if(off > ip->size || off + n < off)
80101a79:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101a7c:	39 70 58             	cmp    %esi,0x58(%eax)
80101a7f:	0f 82 eb 00 00 00    	jb     80101b70 <writei+0x120>
80101a85:	8b 7d e0             	mov    -0x20(%ebp),%edi
80101a88:	89 f8                	mov    %edi,%eax
80101a8a:	01 f0                	add    %esi,%eax
    return -1;
  if(off + n > MAXFILE*BSIZE)
80101a8c:	3d 00 18 01 00       	cmp    $0x11800,%eax
80101a91:	0f 87 d9 00 00 00    	ja     80101b70 <writei+0x120>
80101a97:	39 c6                	cmp    %eax,%esi
80101a99:	0f 87 d1 00 00 00    	ja     80101b70 <writei+0x120>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101a9f:	85 ff                	test   %edi,%edi
80101aa1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
80101aa8:	74 78                	je     80101b22 <writei+0xd2>
80101aaa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101ab0:	8b 7d d8             	mov    -0x28(%ebp),%edi
80101ab3:	89 f2                	mov    %esi,%edx
    m = min(n - tot, BSIZE - off%BSIZE);
80101ab5:	bb 00 02 00 00       	mov    $0x200,%ebx
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
80101aba:	c1 ea 09             	shr    $0x9,%edx
80101abd:	89 f8                	mov    %edi,%eax
80101abf:	e8 1c f8 ff ff       	call   801012e0 <bmap>
80101ac4:	83 ec 08             	sub    $0x8,%esp
80101ac7:	50                   	push   %eax
80101ac8:	ff 37                	pushl  (%edi)
80101aca:	e8 01 e6 ff ff       	call   801000d0 <bread>
80101acf:	89 c7                	mov    %eax,%edi
    m = min(n - tot, BSIZE - off%BSIZE);
80101ad1:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101ad4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
80101ad7:	89 f1                	mov    %esi,%ecx
80101ad9:	83 c4 0c             	add    $0xc,%esp
80101adc:	81 e1 ff 01 00 00    	and    $0x1ff,%ecx
80101ae2:	29 cb                	sub    %ecx,%ebx
80101ae4:	39 c3                	cmp    %eax,%ebx
80101ae6:	0f 47 d8             	cmova  %eax,%ebx
    memmove(bp->data + off%BSIZE, src, m);
80101ae9:	8d 44 0f 5c          	lea    0x5c(%edi,%ecx,1),%eax
80101aed:	53                   	push   %ebx
80101aee:	ff 75 dc             	pushl  -0x24(%ebp)
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101af1:	01 de                	add    %ebx,%esi
    bp = bread(ip->dev, bmap(ip, off/BSIZE));
    m = min(n - tot, BSIZE - off%BSIZE);
    memmove(bp->data + off%BSIZE, src, m);
80101af3:	50                   	push   %eax
80101af4:	e8 07 2a 00 00       	call   80104500 <memmove>
    log_write(bp);
80101af9:	89 3c 24             	mov    %edi,(%esp)
80101afc:	e8 2f 12 00 00       	call   80102d30 <log_write>
    brelse(bp);
80101b01:	89 3c 24             	mov    %edi,(%esp)
80101b04:	e8 d7 e6 ff ff       	call   801001e0 <brelse>
  if(off > ip->size || off + n < off)
    return -1;
  if(off + n > MAXFILE*BSIZE)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
80101b09:	01 5d e4             	add    %ebx,-0x1c(%ebp)
80101b0c:	01 5d dc             	add    %ebx,-0x24(%ebp)
80101b0f:	83 c4 10             	add    $0x10,%esp
80101b12:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80101b15:	39 55 e0             	cmp    %edx,-0x20(%ebp)
80101b18:	77 96                	ja     80101ab0 <writei+0x60>
    memmove(bp->data + off%BSIZE, src, m);
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
80101b1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
80101b1d:	3b 70 58             	cmp    0x58(%eax),%esi
80101b20:	77 36                	ja     80101b58 <writei+0x108>
    ip->size = off;
    iupdate(ip);
  }
  return n;
80101b22:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
80101b25:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b28:	5b                   	pop    %ebx
80101b29:	5e                   	pop    %esi
80101b2a:	5f                   	pop    %edi
80101b2b:	5d                   	pop    %ebp
80101b2c:	c3                   	ret    
80101b2d:	8d 76 00             	lea    0x0(%esi),%esi
{
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
80101b30:	0f bf 40 52          	movswl 0x52(%eax),%eax
80101b34:	66 83 f8 09          	cmp    $0x9,%ax
80101b38:	77 36                	ja     80101b70 <writei+0x120>
80101b3a:	8b 04 c5 c4 09 11 80 	mov    -0x7feef63c(,%eax,8),%eax
80101b41:	85 c0                	test   %eax,%eax
80101b43:	74 2b                	je     80101b70 <writei+0x120>
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b45:	89 7d 10             	mov    %edi,0x10(%ebp)
  if(n > 0 && off > ip->size){
    ip->size = off;
    iupdate(ip);
  }
  return n;
}
80101b48:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101b4b:	5b                   	pop    %ebx
80101b4c:	5e                   	pop    %esi
80101b4d:	5f                   	pop    %edi
80101b4e:	5d                   	pop    %ebp
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
    return devsw[ip->major].write(ip, src, n);
80101b4f:	ff e0                	jmp    *%eax
80101b51:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b58:	8b 45 d8             	mov    -0x28(%ebp),%eax
    iupdate(ip);
80101b5b:	83 ec 0c             	sub    $0xc,%esp
    log_write(bp);
    brelse(bp);
  }

  if(n > 0 && off > ip->size){
    ip->size = off;
80101b5e:	89 70 58             	mov    %esi,0x58(%eax)
    iupdate(ip);
80101b61:	50                   	push   %eax
80101b62:	e8 59 fa ff ff       	call   801015c0 <iupdate>
80101b67:	83 c4 10             	add    $0x10,%esp
80101b6a:	eb b6                	jmp    80101b22 <writei+0xd2>
80101b6c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint tot, m;
  struct buf *bp;

  if(ip->type == T_DEV){
    if(ip->major < 0 || ip->major >= NDEV || !devsw[ip->major].write)
      return -1;
80101b70:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101b75:	eb ae                	jmp    80101b25 <writei+0xd5>
80101b77:	89 f6                	mov    %esi,%esi
80101b79:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101b80 <namecmp>:
//PAGEBREAK!
// Directories

int
namecmp(const char *s, const char *t)
{
80101b80:	55                   	push   %ebp
80101b81:	89 e5                	mov    %esp,%ebp
80101b83:	83 ec 0c             	sub    $0xc,%esp
  return strncmp(s, t, DIRSIZ);
80101b86:	6a 0e                	push   $0xe
80101b88:	ff 75 0c             	pushl  0xc(%ebp)
80101b8b:	ff 75 08             	pushl  0x8(%ebp)
80101b8e:	e8 ed 29 00 00       	call   80104580 <strncmp>
}
80101b93:	c9                   	leave  
80101b94:	c3                   	ret    
80101b95:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ba0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
80101ba0:	55                   	push   %ebp
80101ba1:	89 e5                	mov    %esp,%ebp
80101ba3:	57                   	push   %edi
80101ba4:	56                   	push   %esi
80101ba5:	53                   	push   %ebx
80101ba6:	83 ec 1c             	sub    $0x1c,%esp
80101ba9:	8b 5d 08             	mov    0x8(%ebp),%ebx
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
80101bac:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80101bb1:	0f 85 80 00 00 00    	jne    80101c37 <dirlookup+0x97>
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
80101bb7:	8b 53 58             	mov    0x58(%ebx),%edx
80101bba:	31 ff                	xor    %edi,%edi
80101bbc:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101bbf:	85 d2                	test   %edx,%edx
80101bc1:	75 0d                	jne    80101bd0 <dirlookup+0x30>
80101bc3:	eb 5b                	jmp    80101c20 <dirlookup+0x80>
80101bc5:	8d 76 00             	lea    0x0(%esi),%esi
80101bc8:	83 c7 10             	add    $0x10,%edi
80101bcb:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101bce:	76 50                	jbe    80101c20 <dirlookup+0x80>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101bd0:	6a 10                	push   $0x10
80101bd2:	57                   	push   %edi
80101bd3:	56                   	push   %esi
80101bd4:	53                   	push   %ebx
80101bd5:	e8 76 fd ff ff       	call   80101950 <readi>
80101bda:	83 c4 10             	add    $0x10,%esp
80101bdd:	83 f8 10             	cmp    $0x10,%eax
80101be0:	75 48                	jne    80101c2a <dirlookup+0x8a>
      panic("dirlookup read");
    if(de.inum == 0)
80101be2:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101be7:	74 df                	je     80101bc8 <dirlookup+0x28>
// Directories

int
namecmp(const char *s, const char *t)
{
  return strncmp(s, t, DIRSIZ);
80101be9:	8d 45 da             	lea    -0x26(%ebp),%eax
80101bec:	83 ec 04             	sub    $0x4,%esp
80101bef:	6a 0e                	push   $0xe
80101bf1:	50                   	push   %eax
80101bf2:	ff 75 0c             	pushl  0xc(%ebp)
80101bf5:	e8 86 29 00 00       	call   80104580 <strncmp>
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
80101bfa:	83 c4 10             	add    $0x10,%esp
80101bfd:	85 c0                	test   %eax,%eax
80101bff:	75 c7                	jne    80101bc8 <dirlookup+0x28>
      // entry matches path element
      if(poff)
80101c01:	8b 45 10             	mov    0x10(%ebp),%eax
80101c04:	85 c0                	test   %eax,%eax
80101c06:	74 05                	je     80101c0d <dirlookup+0x6d>
        *poff = off;
80101c08:	8b 45 10             	mov    0x10(%ebp),%eax
80101c0b:	89 38                	mov    %edi,(%eax)
      inum = de.inum;
      return iget(dp->dev, inum);
80101c0d:	0f b7 55 d8          	movzwl -0x28(%ebp),%edx
80101c11:	8b 03                	mov    (%ebx),%eax
80101c13:	e8 f8 f5 ff ff       	call   80101210 <iget>
    }
  }

  return 0;
}
80101c18:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101c1b:	5b                   	pop    %ebx
80101c1c:	5e                   	pop    %esi
80101c1d:	5f                   	pop    %edi
80101c1e:	5d                   	pop    %ebp
80101c1f:	c3                   	ret    
80101c20:	8d 65 f4             	lea    -0xc(%ebp),%esp
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
80101c23:	31 c0                	xor    %eax,%eax
}
80101c25:	5b                   	pop    %ebx
80101c26:	5e                   	pop    %esi
80101c27:	5f                   	pop    %edi
80101c28:	5d                   	pop    %ebp
80101c29:	c3                   	ret    
  if(dp->type != T_DIR)
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlookup read");
80101c2a:	83 ec 0c             	sub    $0xc,%esp
80101c2d:	68 b9 71 10 80       	push   $0x801071b9
80101c32:	e8 39 e7 ff ff       	call   80100370 <panic>
{
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    panic("dirlookup not DIR");
80101c37:	83 ec 0c             	sub    $0xc,%esp
80101c3a:	68 a7 71 10 80       	push   $0x801071a7
80101c3f:	e8 2c e7 ff ff       	call   80100370 <panic>
80101c44:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101c4a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80101c50 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c50:	55                   	push   %ebp
80101c51:	89 e5                	mov    %esp,%ebp
80101c53:	57                   	push   %edi
80101c54:	56                   	push   %esi
80101c55:	53                   	push   %ebx
80101c56:	89 cf                	mov    %ecx,%edi
80101c58:	89 c3                	mov    %eax,%ebx
80101c5a:	83 ec 1c             	sub    $0x1c,%esp
  struct inode *ip, *next;

  if(*path == '/')
80101c5d:	80 38 2f             	cmpb   $0x2f,(%eax)
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
80101c60:	89 55 e0             	mov    %edx,-0x20(%ebp)
  struct inode *ip, *next;

  if(*path == '/')
80101c63:	0f 84 53 01 00 00    	je     80101dbc <namex+0x16c>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c69:	e8 32 1b 00 00       	call   801037a0 <myproc>
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c6e:	83 ec 0c             	sub    $0xc,%esp
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
80101c71:	8b 70 70             	mov    0x70(%eax),%esi
// Increment reference count for ip.
// Returns ip to enable ip = idup(ip1) idiom.
struct inode*
idup(struct inode *ip)
{
  acquire(&icache.lock);
80101c74:	68 40 0a 11 80       	push   $0x80110a40
80101c79:	e8 d2 26 00 00       	call   80104350 <acquire>
  ip->ref++;
80101c7e:	83 46 08 01          	addl   $0x1,0x8(%esi)
  release(&icache.lock);
80101c82:	c7 04 24 40 0a 11 80 	movl   $0x80110a40,(%esp)
80101c89:	e8 72 27 00 00       	call   80104400 <release>
80101c8e:	83 c4 10             	add    $0x10,%esp
80101c91:	eb 08                	jmp    80101c9b <namex+0x4b>
80101c93:	90                   	nop
80101c94:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
{
  char *s;
  int len;

  while(*path == '/')
    path++;
80101c98:	83 c3 01             	add    $0x1,%ebx
skipelem(char *path, char *name)
{
  char *s;
  int len;

  while(*path == '/')
80101c9b:	0f b6 03             	movzbl (%ebx),%eax
80101c9e:	3c 2f                	cmp    $0x2f,%al
80101ca0:	74 f6                	je     80101c98 <namex+0x48>
    path++;
  if(*path == 0)
80101ca2:	84 c0                	test   %al,%al
80101ca4:	0f 84 e3 00 00 00    	je     80101d8d <namex+0x13d>
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101caa:	0f b6 03             	movzbl (%ebx),%eax
80101cad:	89 da                	mov    %ebx,%edx
80101caf:	84 c0                	test   %al,%al
80101cb1:	0f 84 ac 00 00 00    	je     80101d63 <namex+0x113>
80101cb7:	3c 2f                	cmp    $0x2f,%al
80101cb9:	75 09                	jne    80101cc4 <namex+0x74>
80101cbb:	e9 a3 00 00 00       	jmp    80101d63 <namex+0x113>
80101cc0:	84 c0                	test   %al,%al
80101cc2:	74 0a                	je     80101cce <namex+0x7e>
    path++;
80101cc4:	83 c2 01             	add    $0x1,%edx
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101cc7:	0f b6 02             	movzbl (%edx),%eax
80101cca:	3c 2f                	cmp    $0x2f,%al
80101ccc:	75 f2                	jne    80101cc0 <namex+0x70>
80101cce:	89 d1                	mov    %edx,%ecx
80101cd0:	29 d9                	sub    %ebx,%ecx
    path++;
  len = path - s;
  if(len >= DIRSIZ)
80101cd2:	83 f9 0d             	cmp    $0xd,%ecx
80101cd5:	0f 8e 8d 00 00 00    	jle    80101d68 <namex+0x118>
    memmove(name, s, DIRSIZ);
80101cdb:	83 ec 04             	sub    $0x4,%esp
80101cde:	89 55 e4             	mov    %edx,-0x1c(%ebp)
80101ce1:	6a 0e                	push   $0xe
80101ce3:	53                   	push   %ebx
80101ce4:	57                   	push   %edi
80101ce5:	e8 16 28 00 00       	call   80104500 <memmove>
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
80101ced:	83 c4 10             	add    $0x10,%esp
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
    path++;
80101cf0:	89 d3                	mov    %edx,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101cf2:	80 3a 2f             	cmpb   $0x2f,(%edx)
80101cf5:	75 11                	jne    80101d08 <namex+0xb8>
80101cf7:	89 f6                	mov    %esi,%esi
80101cf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    path++;
80101d00:	83 c3 01             	add    $0x1,%ebx
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
    name[len] = 0;
  }
  while(*path == '/')
80101d03:	80 3b 2f             	cmpb   $0x2f,(%ebx)
80101d06:	74 f8                	je     80101d00 <namex+0xb0>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
80101d08:	83 ec 0c             	sub    $0xc,%esp
80101d0b:	56                   	push   %esi
80101d0c:	e8 5f f9 ff ff       	call   80101670 <ilock>
    if(ip->type != T_DIR){
80101d11:	83 c4 10             	add    $0x10,%esp
80101d14:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80101d19:	0f 85 7f 00 00 00    	jne    80101d9e <namex+0x14e>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
80101d1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
80101d22:	85 d2                	test   %edx,%edx
80101d24:	74 09                	je     80101d2f <namex+0xdf>
80101d26:	80 3b 00             	cmpb   $0x0,(%ebx)
80101d29:	0f 84 a3 00 00 00    	je     80101dd2 <namex+0x182>
      // Stop one level early.
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
80101d2f:	83 ec 04             	sub    $0x4,%esp
80101d32:	6a 00                	push   $0x0
80101d34:	57                   	push   %edi
80101d35:	56                   	push   %esi
80101d36:	e8 65 fe ff ff       	call   80101ba0 <dirlookup>
80101d3b:	83 c4 10             	add    $0x10,%esp
80101d3e:	85 c0                	test   %eax,%eax
80101d40:	74 5c                	je     80101d9e <namex+0x14e>

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d42:	83 ec 0c             	sub    $0xc,%esp
80101d45:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80101d48:	56                   	push   %esi
80101d49:	e8 02 fa ff ff       	call   80101750 <iunlock>
  iput(ip);
80101d4e:	89 34 24             	mov    %esi,(%esp)
80101d51:	e8 4a fa ff ff       	call   801017a0 <iput>
80101d56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80101d59:	83 c4 10             	add    $0x10,%esp
80101d5c:	89 c6                	mov    %eax,%esi
80101d5e:	e9 38 ff ff ff       	jmp    80101c9b <namex+0x4b>
  while(*path == '/')
    path++;
  if(*path == 0)
    return 0;
  s = path;
  while(*path != '/' && *path != 0)
80101d63:	31 c9                	xor    %ecx,%ecx
80101d65:	8d 76 00             	lea    0x0(%esi),%esi
    path++;
  len = path - s;
  if(len >= DIRSIZ)
    memmove(name, s, DIRSIZ);
  else {
    memmove(name, s, len);
80101d68:	83 ec 04             	sub    $0x4,%esp
80101d6b:	89 55 dc             	mov    %edx,-0x24(%ebp)
80101d6e:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80101d71:	51                   	push   %ecx
80101d72:	53                   	push   %ebx
80101d73:	57                   	push   %edi
80101d74:	e8 87 27 00 00       	call   80104500 <memmove>
    name[len] = 0;
80101d79:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80101d7c:	8b 55 dc             	mov    -0x24(%ebp),%edx
80101d7f:	83 c4 10             	add    $0x10,%esp
80101d82:	c6 04 0f 00          	movb   $0x0,(%edi,%ecx,1)
80101d86:	89 d3                	mov    %edx,%ebx
80101d88:	e9 65 ff ff ff       	jmp    80101cf2 <namex+0xa2>
      return 0;
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
80101d8d:	8b 45 e0             	mov    -0x20(%ebp),%eax
80101d90:	85 c0                	test   %eax,%eax
80101d92:	75 54                	jne    80101de8 <namex+0x198>
80101d94:	89 f0                	mov    %esi,%eax
    iput(ip);
    return 0;
  }
  return ip;
}
80101d96:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101d99:	5b                   	pop    %ebx
80101d9a:	5e                   	pop    %esi
80101d9b:	5f                   	pop    %edi
80101d9c:	5d                   	pop    %ebp
80101d9d:	c3                   	ret    

// Common idiom: unlock, then put.
void
iunlockput(struct inode *ip)
{
  iunlock(ip);
80101d9e:	83 ec 0c             	sub    $0xc,%esp
80101da1:	56                   	push   %esi
80101da2:	e8 a9 f9 ff ff       	call   80101750 <iunlock>
  iput(ip);
80101da7:	89 34 24             	mov    %esi,(%esp)
80101daa:	e8 f1 f9 ff ff       	call   801017a0 <iput>
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101daf:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db2:	8d 65 f4             	lea    -0xc(%ebp),%esp
      iunlock(ip);
      return ip;
    }
    if((next = dirlookup(ip, name, 0)) == 0){
      iunlockput(ip);
      return 0;
80101db5:	31 c0                	xor    %eax,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101db7:	5b                   	pop    %ebx
80101db8:	5e                   	pop    %esi
80101db9:	5f                   	pop    %edi
80101dba:	5d                   	pop    %ebp
80101dbb:	c3                   	ret    
namex(char *path, int nameiparent, char *name)
{
  struct inode *ip, *next;

  if(*path == '/')
    ip = iget(ROOTDEV, ROOTINO);
80101dbc:	ba 01 00 00 00       	mov    $0x1,%edx
80101dc1:	b8 01 00 00 00       	mov    $0x1,%eax
80101dc6:	e8 45 f4 ff ff       	call   80101210 <iget>
80101dcb:	89 c6                	mov    %eax,%esi
80101dcd:	e9 c9 fe ff ff       	jmp    80101c9b <namex+0x4b>
      iunlockput(ip);
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
80101dd2:	83 ec 0c             	sub    $0xc,%esp
80101dd5:	56                   	push   %esi
80101dd6:	e8 75 f9 ff ff       	call   80101750 <iunlock>
      return ip;
80101ddb:	83 c4 10             	add    $0x10,%esp
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101dde:	8d 65 f4             	lea    -0xc(%ebp),%esp
      return 0;
    }
    if(nameiparent && *path == '\0'){
      // Stop one level early.
      iunlock(ip);
      return ip;
80101de1:	89 f0                	mov    %esi,%eax
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
80101de3:	5b                   	pop    %ebx
80101de4:	5e                   	pop    %esi
80101de5:	5f                   	pop    %edi
80101de6:	5d                   	pop    %ebp
80101de7:	c3                   	ret    
    }
    iunlockput(ip);
    ip = next;
  }
  if(nameiparent){
    iput(ip);
80101de8:	83 ec 0c             	sub    $0xc,%esp
80101deb:	56                   	push   %esi
80101dec:	e8 af f9 ff ff       	call   801017a0 <iput>
    return 0;
80101df1:	83 c4 10             	add    $0x10,%esp
80101df4:	31 c0                	xor    %eax,%eax
80101df6:	eb 9e                	jmp    80101d96 <namex+0x146>
80101df8:	90                   	nop
80101df9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80101e00 <dirlink>:
}

// Write a new directory entry (name, inum) into the directory dp.
int
dirlink(struct inode *dp, char *name, uint inum)
{
80101e00:	55                   	push   %ebp
80101e01:	89 e5                	mov    %esp,%ebp
80101e03:	57                   	push   %edi
80101e04:	56                   	push   %esi
80101e05:	53                   	push   %ebx
80101e06:	83 ec 20             	sub    $0x20,%esp
80101e09:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int off;
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
80101e0c:	6a 00                	push   $0x0
80101e0e:	ff 75 0c             	pushl  0xc(%ebp)
80101e11:	53                   	push   %ebx
80101e12:	e8 89 fd ff ff       	call   80101ba0 <dirlookup>
80101e17:	83 c4 10             	add    $0x10,%esp
80101e1a:	85 c0                	test   %eax,%eax
80101e1c:	75 67                	jne    80101e85 <dirlink+0x85>
    iput(ip);
    return -1;
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
80101e1e:	8b 7b 58             	mov    0x58(%ebx),%edi
80101e21:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e24:	85 ff                	test   %edi,%edi
80101e26:	74 29                	je     80101e51 <dirlink+0x51>
80101e28:	31 ff                	xor    %edi,%edi
80101e2a:	8d 75 d8             	lea    -0x28(%ebp),%esi
80101e2d:	eb 09                	jmp    80101e38 <dirlink+0x38>
80101e2f:	90                   	nop
80101e30:	83 c7 10             	add    $0x10,%edi
80101e33:	39 7b 58             	cmp    %edi,0x58(%ebx)
80101e36:	76 19                	jbe    80101e51 <dirlink+0x51>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e38:	6a 10                	push   $0x10
80101e3a:	57                   	push   %edi
80101e3b:	56                   	push   %esi
80101e3c:	53                   	push   %ebx
80101e3d:	e8 0e fb ff ff       	call   80101950 <readi>
80101e42:	83 c4 10             	add    $0x10,%esp
80101e45:	83 f8 10             	cmp    $0x10,%eax
80101e48:	75 4e                	jne    80101e98 <dirlink+0x98>
      panic("dirlink read");
    if(de.inum == 0)
80101e4a:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80101e4f:	75 df                	jne    80101e30 <dirlink+0x30>
      break;
  }

  strncpy(de.name, name, DIRSIZ);
80101e51:	8d 45 da             	lea    -0x26(%ebp),%eax
80101e54:	83 ec 04             	sub    $0x4,%esp
80101e57:	6a 0e                	push   $0xe
80101e59:	ff 75 0c             	pushl  0xc(%ebp)
80101e5c:	50                   	push   %eax
80101e5d:	e8 8e 27 00 00       	call   801045f0 <strncpy>
  de.inum = inum;
80101e62:	8b 45 10             	mov    0x10(%ebp),%eax
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e65:	6a 10                	push   $0x10
80101e67:	57                   	push   %edi
80101e68:	56                   	push   %esi
80101e69:	53                   	push   %ebx
    if(de.inum == 0)
      break;
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
80101e6a:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80101e6e:	e8 dd fb ff ff       	call   80101a50 <writei>
80101e73:	83 c4 20             	add    $0x20,%esp
80101e76:	83 f8 10             	cmp    $0x10,%eax
80101e79:	75 2a                	jne    80101ea5 <dirlink+0xa5>
    panic("dirlink");

  return 0;
80101e7b:	31 c0                	xor    %eax,%eax
}
80101e7d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80101e80:	5b                   	pop    %ebx
80101e81:	5e                   	pop    %esi
80101e82:	5f                   	pop    %edi
80101e83:	5d                   	pop    %ebp
80101e84:	c3                   	ret    
  struct dirent de;
  struct inode *ip;

  // Check that name is not present.
  if((ip = dirlookup(dp, name, 0)) != 0){
    iput(ip);
80101e85:	83 ec 0c             	sub    $0xc,%esp
80101e88:	50                   	push   %eax
80101e89:	e8 12 f9 ff ff       	call   801017a0 <iput>
    return -1;
80101e8e:	83 c4 10             	add    $0x10,%esp
80101e91:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80101e96:	eb e5                	jmp    80101e7d <dirlink+0x7d>
  }

  // Look for an empty dirent.
  for(off = 0; off < dp->size; off += sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("dirlink read");
80101e98:	83 ec 0c             	sub    $0xc,%esp
80101e9b:	68 c8 71 10 80       	push   $0x801071c8
80101ea0:	e8 cb e4 ff ff       	call   80100370 <panic>
  }

  strncpy(de.name, name, DIRSIZ);
  de.inum = inum;
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("dirlink");
80101ea5:	83 ec 0c             	sub    $0xc,%esp
80101ea8:	68 c2 77 10 80       	push   $0x801077c2
80101ead:	e8 be e4 ff ff       	call   80100370 <panic>
80101eb2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80101eb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ec0 <namei>:
  return ip;
}

struct inode*
namei(char *path)
{
80101ec0:	55                   	push   %ebp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec1:	31 d2                	xor    %edx,%edx
  return ip;
}

struct inode*
namei(char *path)
{
80101ec3:	89 e5                	mov    %esp,%ebp
80101ec5:	83 ec 18             	sub    $0x18,%esp
  char name[DIRSIZ];
  return namex(path, 0, name);
80101ec8:	8b 45 08             	mov    0x8(%ebp),%eax
80101ecb:	8d 4d ea             	lea    -0x16(%ebp),%ecx
80101ece:	e8 7d fd ff ff       	call   80101c50 <namex>
}
80101ed3:	c9                   	leave  
80101ed4:	c3                   	ret    
80101ed5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101ed9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101ee0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
80101ee0:	55                   	push   %ebp
  return namex(path, 1, name);
80101ee1:	ba 01 00 00 00       	mov    $0x1,%edx
  return namex(path, 0, name);
}

struct inode*
nameiparent(char *path, char *name)
{
80101ee6:	89 e5                	mov    %esp,%ebp
  return namex(path, 1, name);
80101ee8:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80101eeb:	8b 45 08             	mov    0x8(%ebp),%eax
}
80101eee:	5d                   	pop    %ebp
}

struct inode*
nameiparent(char *path, char *name)
{
  return namex(path, 1, name);
80101eef:	e9 5c fd ff ff       	jmp    80101c50 <namex>
80101ef4:	66 90                	xchg   %ax,%ax
80101ef6:	66 90                	xchg   %ax,%ax
80101ef8:	66 90                	xchg   %ax,%ax
80101efa:	66 90                	xchg   %ax,%ax
80101efc:	66 90                	xchg   %ax,%ax
80101efe:	66 90                	xchg   %ax,%ax

80101f00 <idestart>:
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f00:	55                   	push   %ebp
  if(b == 0)
80101f01:	85 c0                	test   %eax,%eax
}

// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
80101f03:	89 e5                	mov    %esp,%ebp
80101f05:	56                   	push   %esi
80101f06:	53                   	push   %ebx
  if(b == 0)
80101f07:	0f 84 ad 00 00 00    	je     80101fba <idestart+0xba>
    panic("idestart");
  if(b->blockno >= FSSIZE)
80101f0d:	8b 58 08             	mov    0x8(%eax),%ebx
80101f10:	89 c1                	mov    %eax,%ecx
80101f12:	81 fb e7 03 00 00    	cmp    $0x3e7,%ebx
80101f18:	0f 87 8f 00 00 00    	ja     80101fad <idestart+0xad>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101f1e:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f23:	90                   	nop
80101f24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80101f28:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80101f29:	83 e0 c0             	and    $0xffffffc0,%eax
80101f2c:	3c 40                	cmp    $0x40,%al
80101f2e:	75 f8                	jne    80101f28 <idestart+0x28>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80101f30:	31 f6                	xor    %esi,%esi
80101f32:	ba f6 03 00 00       	mov    $0x3f6,%edx
80101f37:	89 f0                	mov    %esi,%eax
80101f39:	ee                   	out    %al,(%dx)
80101f3a:	ba f2 01 00 00       	mov    $0x1f2,%edx
80101f3f:	b8 01 00 00 00       	mov    $0x1,%eax
80101f44:	ee                   	out    %al,(%dx)
80101f45:	ba f3 01 00 00       	mov    $0x1f3,%edx
80101f4a:	89 d8                	mov    %ebx,%eax
80101f4c:	ee                   	out    %al,(%dx)
80101f4d:	89 d8                	mov    %ebx,%eax
80101f4f:	ba f4 01 00 00       	mov    $0x1f4,%edx
80101f54:	c1 f8 08             	sar    $0x8,%eax
80101f57:	ee                   	out    %al,(%dx)
80101f58:	ba f5 01 00 00       	mov    $0x1f5,%edx
80101f5d:	89 f0                	mov    %esi,%eax
80101f5f:	ee                   	out    %al,(%dx)
80101f60:	0f b6 41 04          	movzbl 0x4(%ecx),%eax
80101f64:	ba f6 01 00 00       	mov    $0x1f6,%edx
80101f69:	83 e0 01             	and    $0x1,%eax
80101f6c:	c1 e0 04             	shl    $0x4,%eax
80101f6f:	83 c8 e0             	or     $0xffffffe0,%eax
80101f72:	ee                   	out    %al,(%dx)
  outb(0x1f2, sector_per_block);  // number of sectors
  outb(0x1f3, sector & 0xff);
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
80101f73:	f6 01 04             	testb  $0x4,(%ecx)
80101f76:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101f7b:	75 13                	jne    80101f90 <idestart+0x90>
80101f7d:	b8 20 00 00 00       	mov    $0x20,%eax
80101f82:	ee                   	out    %al,(%dx)
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101f83:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101f86:	5b                   	pop    %ebx
80101f87:	5e                   	pop    %esi
80101f88:	5d                   	pop    %ebp
80101f89:	c3                   	ret    
80101f8a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80101f90:	b8 30 00 00 00       	mov    $0x30,%eax
80101f95:	ee                   	out    %al,(%dx)
}

static inline void
outsl(int port, const void *addr, int cnt)
{
  asm volatile("cld; rep outsl" :
80101f96:	ba f0 01 00 00       	mov    $0x1f0,%edx
  outb(0x1f4, (sector >> 8) & 0xff);
  outb(0x1f5, (sector >> 16) & 0xff);
  outb(0x1f6, 0xe0 | ((b->dev&1)<<4) | ((sector>>24)&0x0f));
  if(b->flags & B_DIRTY){
    outb(0x1f7, write_cmd);
    outsl(0x1f0, b->data, BSIZE/4);
80101f9b:	8d 71 5c             	lea    0x5c(%ecx),%esi
80101f9e:	b9 80 00 00 00       	mov    $0x80,%ecx
80101fa3:	fc                   	cld    
80101fa4:	f3 6f                	rep outsl %ds:(%esi),(%dx)
  } else {
    outb(0x1f7, read_cmd);
  }
}
80101fa6:	8d 65 f8             	lea    -0x8(%ebp),%esp
80101fa9:	5b                   	pop    %ebx
80101faa:	5e                   	pop    %esi
80101fab:	5d                   	pop    %ebp
80101fac:	c3                   	ret    
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
  if(b->blockno >= FSSIZE)
    panic("incorrect blockno");
80101fad:	83 ec 0c             	sub    $0xc,%esp
80101fb0:	68 34 72 10 80       	push   $0x80107234
80101fb5:	e8 b6 e3 ff ff       	call   80100370 <panic>
// Start the request for b.  Caller must hold idelock.
static void
idestart(struct buf *b)
{
  if(b == 0)
    panic("idestart");
80101fba:	83 ec 0c             	sub    $0xc,%esp
80101fbd:	68 2b 72 10 80       	push   $0x8010722b
80101fc2:	e8 a9 e3 ff ff       	call   80100370 <panic>
80101fc7:	89 f6                	mov    %esi,%esi
80101fc9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80101fd0 <ideinit>:
  return 0;
}

void
ideinit(void)
{
80101fd0:	55                   	push   %ebp
80101fd1:	89 e5                	mov    %esp,%ebp
80101fd3:	83 ec 10             	sub    $0x10,%esp
  int i;

  initlock(&idelock, "ide");
80101fd6:	68 46 72 10 80       	push   $0x80107246
80101fdb:	68 e0 a5 10 80       	push   $0x8010a5e0
80101fe0:	e8 0b 22 00 00       	call   801041f0 <initlock>
  ioapicenable(IRQ_IDE, ncpu - 1);
80101fe5:	58                   	pop    %eax
80101fe6:	a1 60 2d 11 80       	mov    0x80112d60,%eax
80101feb:	5a                   	pop    %edx
80101fec:	83 e8 01             	sub    $0x1,%eax
80101fef:	50                   	push   %eax
80101ff0:	6a 0e                	push   $0xe
80101ff2:	e8 a9 02 00 00       	call   801022a0 <ioapicenable>
80101ff7:	83 c4 10             	add    $0x10,%esp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80101ffa:	ba f7 01 00 00       	mov    $0x1f7,%edx
80101fff:	90                   	nop
80102000:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
80102001:	83 e0 c0             	and    $0xffffffc0,%eax
80102004:	3c 40                	cmp    $0x40,%al
80102006:	75 f8                	jne    80102000 <ideinit+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102008:	ba f6 01 00 00       	mov    $0x1f6,%edx
8010200d:	b8 f0 ff ff ff       	mov    $0xfffffff0,%eax
80102012:	ee                   	out    %al,(%dx)
80102013:	b9 e8 03 00 00       	mov    $0x3e8,%ecx
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102018:	ba f7 01 00 00       	mov    $0x1f7,%edx
8010201d:	eb 06                	jmp    80102025 <ideinit+0x55>
8010201f:	90                   	nop
  ioapicenable(IRQ_IDE, ncpu - 1);
  idewait(0);

  // Check if disk 1 is present
  outb(0x1f6, 0xe0 | (1<<4));
  for(i=0; i<1000; i++){
80102020:	83 e9 01             	sub    $0x1,%ecx
80102023:	74 0f                	je     80102034 <ideinit+0x64>
80102025:	ec                   	in     (%dx),%al
    if(inb(0x1f7) != 0){
80102026:	84 c0                	test   %al,%al
80102028:	74 f6                	je     80102020 <ideinit+0x50>
      havedisk1 = 1;
8010202a:	c7 05 c0 a5 10 80 01 	movl   $0x1,0x8010a5c0
80102031:	00 00 00 
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102034:	ba f6 01 00 00       	mov    $0x1f6,%edx
80102039:	b8 e0 ff ff ff       	mov    $0xffffffe0,%eax
8010203e:	ee                   	out    %al,(%dx)
    }
  }

  // Switch back to disk 0.
  outb(0x1f6, 0xe0 | (0<<4));
}
8010203f:	c9                   	leave  
80102040:	c3                   	ret    
80102041:	eb 0d                	jmp    80102050 <ideintr>
80102043:	90                   	nop
80102044:	90                   	nop
80102045:	90                   	nop
80102046:	90                   	nop
80102047:	90                   	nop
80102048:	90                   	nop
80102049:	90                   	nop
8010204a:	90                   	nop
8010204b:	90                   	nop
8010204c:	90                   	nop
8010204d:	90                   	nop
8010204e:	90                   	nop
8010204f:	90                   	nop

80102050 <ideintr>:
}

// Interrupt handler.
void
ideintr(void)
{
80102050:	55                   	push   %ebp
80102051:	89 e5                	mov    %esp,%ebp
80102053:	57                   	push   %edi
80102054:	56                   	push   %esi
80102055:	53                   	push   %ebx
80102056:	83 ec 18             	sub    $0x18,%esp
  struct buf *b;

  // First queued buffer is the active request.
  acquire(&idelock);
80102059:	68 e0 a5 10 80       	push   $0x8010a5e0
8010205e:	e8 ed 22 00 00       	call   80104350 <acquire>

  if((b = idequeue) == 0){
80102063:	8b 1d c4 a5 10 80    	mov    0x8010a5c4,%ebx
80102069:	83 c4 10             	add    $0x10,%esp
8010206c:	85 db                	test   %ebx,%ebx
8010206e:	74 34                	je     801020a4 <ideintr+0x54>
    release(&idelock);
    return;
  }
  idequeue = b->qnext;
80102070:	8b 43 58             	mov    0x58(%ebx),%eax
80102073:	a3 c4 a5 10 80       	mov    %eax,0x8010a5c4

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
80102078:	8b 33                	mov    (%ebx),%esi
8010207a:	f7 c6 04 00 00 00    	test   $0x4,%esi
80102080:	74 3e                	je     801020c0 <ideintr+0x70>
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102082:	83 e6 fb             	and    $0xfffffffb,%esi
  wakeup(b);
80102085:	83 ec 0c             	sub    $0xc,%esp
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);

  // Wake process waiting for this buf.
  b->flags |= B_VALID;
  b->flags &= ~B_DIRTY;
80102088:	83 ce 02             	or     $0x2,%esi
8010208b:	89 33                	mov    %esi,(%ebx)
  wakeup(b);
8010208d:	53                   	push   %ebx
8010208e:	e8 7d 1e 00 00       	call   80103f10 <wakeup>

  // Start disk on next buf in queue.
  if(idequeue != 0)
80102093:	a1 c4 a5 10 80       	mov    0x8010a5c4,%eax
80102098:	83 c4 10             	add    $0x10,%esp
8010209b:	85 c0                	test   %eax,%eax
8010209d:	74 05                	je     801020a4 <ideintr+0x54>
    idestart(idequeue);
8010209f:	e8 5c fe ff ff       	call   80101f00 <idestart>

  // First queued buffer is the active request.
  acquire(&idelock);

  if((b = idequeue) == 0){
    release(&idelock);
801020a4:	83 ec 0c             	sub    $0xc,%esp
801020a7:	68 e0 a5 10 80       	push   $0x8010a5e0
801020ac:	e8 4f 23 00 00       	call   80104400 <release>
  // Start disk on next buf in queue.
  if(idequeue != 0)
    idestart(idequeue);

  release(&idelock);
}
801020b1:	8d 65 f4             	lea    -0xc(%ebp),%esp
801020b4:	5b                   	pop    %ebx
801020b5:	5e                   	pop    %esi
801020b6:	5f                   	pop    %edi
801020b7:	5d                   	pop    %ebp
801020b8:	c3                   	ret    
801020b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801020c0:	ba f7 01 00 00       	mov    $0x1f7,%edx
801020c5:	8d 76 00             	lea    0x0(%esi),%esi
801020c8:	ec                   	in     (%dx),%al
static int
idewait(int checkerr)
{
  int r;

  while(((r = inb(0x1f7)) & (IDE_BSY|IDE_DRDY)) != IDE_DRDY)
801020c9:	89 c1                	mov    %eax,%ecx
801020cb:	83 e1 c0             	and    $0xffffffc0,%ecx
801020ce:	80 f9 40             	cmp    $0x40,%cl
801020d1:	75 f5                	jne    801020c8 <ideintr+0x78>
    ;
  if(checkerr && (r & (IDE_DF|IDE_ERR)) != 0)
801020d3:	a8 21                	test   $0x21,%al
801020d5:	75 ab                	jne    80102082 <ideintr+0x32>
  }
  idequeue = b->qnext;

  // Read data if needed.
  if(!(b->flags & B_DIRTY) && idewait(1) >= 0)
    insl(0x1f0, b->data, BSIZE/4);
801020d7:	8d 7b 5c             	lea    0x5c(%ebx),%edi
}

static inline void
insl(int port, void *addr, int cnt)
{
  asm volatile("cld; rep insl" :
801020da:	b9 80 00 00 00       	mov    $0x80,%ecx
801020df:	ba f0 01 00 00       	mov    $0x1f0,%edx
801020e4:	fc                   	cld    
801020e5:	f3 6d                	rep insl (%dx),%es:(%edi)
801020e7:	8b 33                	mov    (%ebx),%esi
801020e9:	eb 97                	jmp    80102082 <ideintr+0x32>
801020eb:	90                   	nop
801020ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801020f0 <iderw>:
// Sync buf with disk.
// If B_DIRTY is set, write buf to disk, clear B_DIRTY, set B_VALID.
// Else if B_VALID is not set, read buf from disk, set B_VALID.
void
iderw(struct buf *b)
{
801020f0:	55                   	push   %ebp
801020f1:	89 e5                	mov    %esp,%ebp
801020f3:	53                   	push   %ebx
801020f4:	83 ec 10             	sub    $0x10,%esp
801020f7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct buf **pp;

  if(!holdingsleep(&b->lock))
801020fa:	8d 43 0c             	lea    0xc(%ebx),%eax
801020fd:	50                   	push   %eax
801020fe:	e8 9d 20 00 00       	call   801041a0 <holdingsleep>
80102103:	83 c4 10             	add    $0x10,%esp
80102106:	85 c0                	test   %eax,%eax
80102108:	0f 84 ad 00 00 00    	je     801021bb <iderw+0xcb>
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
8010210e:	8b 03                	mov    (%ebx),%eax
80102110:	83 e0 06             	and    $0x6,%eax
80102113:	83 f8 02             	cmp    $0x2,%eax
80102116:	0f 84 b9 00 00 00    	je     801021d5 <iderw+0xe5>
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
8010211c:	8b 53 04             	mov    0x4(%ebx),%edx
8010211f:	85 d2                	test   %edx,%edx
80102121:	74 0d                	je     80102130 <iderw+0x40>
80102123:	a1 c0 a5 10 80       	mov    0x8010a5c0,%eax
80102128:	85 c0                	test   %eax,%eax
8010212a:	0f 84 98 00 00 00    	je     801021c8 <iderw+0xd8>
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock
80102130:	83 ec 0c             	sub    $0xc,%esp
80102133:	68 e0 a5 10 80       	push   $0x8010a5e0
80102138:	e8 13 22 00 00       	call   80104350 <acquire>

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010213d:	8b 15 c4 a5 10 80    	mov    0x8010a5c4,%edx
80102143:	83 c4 10             	add    $0x10,%esp
    panic("iderw: ide disk 1 not present");

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
80102146:	c7 43 58 00 00 00 00 	movl   $0x0,0x58(%ebx)
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
8010214d:	85 d2                	test   %edx,%edx
8010214f:	75 09                	jne    8010215a <iderw+0x6a>
80102151:	eb 58                	jmp    801021ab <iderw+0xbb>
80102153:	90                   	nop
80102154:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102158:	89 c2                	mov    %eax,%edx
8010215a:	8b 42 58             	mov    0x58(%edx),%eax
8010215d:	85 c0                	test   %eax,%eax
8010215f:	75 f7                	jne    80102158 <iderw+0x68>
80102161:	83 c2 58             	add    $0x58,%edx
    ;
  *pp = b;
80102164:	89 1a                	mov    %ebx,(%edx)

  // Start disk if necessary.
  if(idequeue == b)
80102166:	3b 1d c4 a5 10 80    	cmp    0x8010a5c4,%ebx
8010216c:	74 44                	je     801021b2 <iderw+0xc2>
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010216e:	8b 03                	mov    (%ebx),%eax
80102170:	83 e0 06             	and    $0x6,%eax
80102173:	83 f8 02             	cmp    $0x2,%eax
80102176:	74 23                	je     8010219b <iderw+0xab>
80102178:	90                   	nop
80102179:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    sleep(b, &idelock);
80102180:	83 ec 08             	sub    $0x8,%esp
80102183:	68 e0 a5 10 80       	push   $0x8010a5e0
80102188:	53                   	push   %ebx
80102189:	e8 c2 1b 00 00       	call   80103d50 <sleep>
  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);

  // Wait for request to finish.
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
8010218e:	8b 03                	mov    (%ebx),%eax
80102190:	83 c4 10             	add    $0x10,%esp
80102193:	83 e0 06             	and    $0x6,%eax
80102196:	83 f8 02             	cmp    $0x2,%eax
80102199:	75 e5                	jne    80102180 <iderw+0x90>
    sleep(b, &idelock);
  }


  release(&idelock);
8010219b:	c7 45 08 e0 a5 10 80 	movl   $0x8010a5e0,0x8(%ebp)
}
801021a2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801021a5:	c9                   	leave  
  while((b->flags & (B_VALID|B_DIRTY)) != B_VALID){
    sleep(b, &idelock);
  }


  release(&idelock);
801021a6:	e9 55 22 00 00       	jmp    80104400 <release>

  acquire(&idelock);  //DOC:acquire-lock

  // Append b to idequeue.
  b->qnext = 0;
  for(pp=&idequeue; *pp; pp=&(*pp)->qnext)  //DOC:insert-queue
801021ab:	ba c4 a5 10 80       	mov    $0x8010a5c4,%edx
801021b0:	eb b2                	jmp    80102164 <iderw+0x74>
    ;
  *pp = b;

  // Start disk if necessary.
  if(idequeue == b)
    idestart(b);
801021b2:	89 d8                	mov    %ebx,%eax
801021b4:	e8 47 fd ff ff       	call   80101f00 <idestart>
801021b9:	eb b3                	jmp    8010216e <iderw+0x7e>
iderw(struct buf *b)
{
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
801021bb:	83 ec 0c             	sub    $0xc,%esp
801021be:	68 4a 72 10 80       	push   $0x8010724a
801021c3:	e8 a8 e1 ff ff       	call   80100370 <panic>
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
  if(b->dev != 0 && !havedisk1)
    panic("iderw: ide disk 1 not present");
801021c8:	83 ec 0c             	sub    $0xc,%esp
801021cb:	68 75 72 10 80       	push   $0x80107275
801021d0:	e8 9b e1 ff ff       	call   80100370 <panic>
  struct buf **pp;

  if(!holdingsleep(&b->lock))
    panic("iderw: buf not locked");
  if((b->flags & (B_VALID|B_DIRTY)) == B_VALID)
    panic("iderw: nothing to do");
801021d5:	83 ec 0c             	sub    $0xc,%esp
801021d8:	68 60 72 10 80       	push   $0x80107260
801021dd:	e8 8e e1 ff ff       	call   80100370 <panic>
801021e2:	66 90                	xchg   %ax,%ax
801021e4:	66 90                	xchg   %ax,%ax
801021e6:	66 90                	xchg   %ax,%ax
801021e8:	66 90                	xchg   %ax,%ax
801021ea:	66 90                	xchg   %ax,%ax
801021ec:	66 90                	xchg   %ax,%ax
801021ee:	66 90                	xchg   %ax,%ax

801021f0 <ioapicinit>:
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021f0:	55                   	push   %ebp
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
801021f1:	c7 05 94 26 11 80 00 	movl   $0xfec00000,0x80112694
801021f8:	00 c0 fe 
  ioapic->data = data;
}

void
ioapicinit(void)
{
801021fb:	89 e5                	mov    %esp,%ebp
801021fd:	56                   	push   %esi
801021fe:	53                   	push   %ebx
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
801021ff:	c7 05 00 00 c0 fe 01 	movl   $0x1,0xfec00000
80102206:	00 00 00 
  return ioapic->data;
80102209:	8b 15 94 26 11 80    	mov    0x80112694,%edx
8010220f:	8b 72 10             	mov    0x10(%edx),%esi
};

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
80102212:	c7 02 00 00 00 00    	movl   $0x0,(%edx)
  return ioapic->data;
80102218:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
8010221e:	0f b6 15 c0 27 11 80 	movzbl 0x801127c0,%edx
ioapicinit(void)
{
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
80102225:	89 f0                	mov    %esi,%eax
80102227:	c1 e8 10             	shr    $0x10,%eax
8010222a:	0f b6 f0             	movzbl %al,%esi

static uint
ioapicread(int reg)
{
  ioapic->reg = reg;
  return ioapic->data;
8010222d:	8b 41 10             	mov    0x10(%ecx),%eax
  int i, id, maxintr;

  ioapic = (volatile struct ioapic*)IOAPIC;
  maxintr = (ioapicread(REG_VER) >> 16) & 0xFF;
  id = ioapicread(REG_ID) >> 24;
  if(id != ioapicid)
80102230:	c1 e8 18             	shr    $0x18,%eax
80102233:	39 d0                	cmp    %edx,%eax
80102235:	74 16                	je     8010224d <ioapicinit+0x5d>
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");
80102237:	83 ec 0c             	sub    $0xc,%esp
8010223a:	68 94 72 10 80       	push   $0x80107294
8010223f:	e8 1c e4 ff ff       	call   80100660 <cprintf>
80102244:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
8010224a:	83 c4 10             	add    $0x10,%esp
8010224d:	83 c6 21             	add    $0x21,%esi
  ioapic->data = data;
}

void
ioapicinit(void)
{
80102250:	ba 10 00 00 00       	mov    $0x10,%edx
80102255:	b8 20 00 00 00       	mov    $0x20,%eax
8010225a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
80102260:	89 11                	mov    %edx,(%ecx)
  ioapic->data = data;
80102262:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
80102268:	89 c3                	mov    %eax,%ebx
8010226a:	81 cb 00 00 01 00    	or     $0x10000,%ebx
80102270:	83 c0 01             	add    $0x1,%eax

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
80102273:	89 59 10             	mov    %ebx,0x10(%ecx)
80102276:	8d 5a 01             	lea    0x1(%edx),%ebx
80102279:	83 c2 02             	add    $0x2,%edx
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010227c:	39 f0                	cmp    %esi,%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
8010227e:	89 19                	mov    %ebx,(%ecx)
  ioapic->data = data;
80102280:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
80102286:	c7 41 10 00 00 00 00 	movl   $0x0,0x10(%ecx)
  if(id != ioapicid)
    cprintf("ioapicinit: id isn't equal to ioapicid; not a MP\n");

  // Mark all interrupts edge-triggered, active high, disabled,
  // and not routed to any CPUs.
  for(i = 0; i <= maxintr; i++){
8010228d:	75 d1                	jne    80102260 <ioapicinit+0x70>
    ioapicwrite(REG_TABLE+2*i, INT_DISABLED | (T_IRQ0 + i));
    ioapicwrite(REG_TABLE+2*i+1, 0);
  }
}
8010228f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102292:	5b                   	pop    %ebx
80102293:	5e                   	pop    %esi
80102294:	5d                   	pop    %ebp
80102295:	c3                   	ret    
80102296:	8d 76 00             	lea    0x0(%esi),%esi
80102299:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801022a0 <ioapicenable>:

void
ioapicenable(int irq, int cpunum)
{
801022a0:	55                   	push   %ebp
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022a1:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
  }
}

void
ioapicenable(int irq, int cpunum)
{
801022a7:	89 e5                	mov    %esp,%ebp
801022a9:	8b 45 08             	mov    0x8(%ebp),%eax
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
801022ac:	8d 50 20             	lea    0x20(%eax),%edx
801022af:	8d 44 00 10          	lea    0x10(%eax,%eax,1),%eax
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022b3:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022b5:	8b 0d 94 26 11 80    	mov    0x80112694,%ecx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022bb:	83 c0 01             	add    $0x1,%eax
  ioapic->data = data;
801022be:	89 51 10             	mov    %edx,0x10(%ecx)
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022c1:	8b 55 0c             	mov    0xc(%ebp),%edx
}

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
801022c4:	89 01                	mov    %eax,(%ecx)
  ioapic->data = data;
801022c6:	a1 94 26 11 80       	mov    0x80112694,%eax
{
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
801022cb:	c1 e2 18             	shl    $0x18,%edx

static void
ioapicwrite(int reg, uint data)
{
  ioapic->reg = reg;
  ioapic->data = data;
801022ce:	89 50 10             	mov    %edx,0x10(%eax)
  // Mark interrupt edge-triggered, active high,
  // enabled, and routed to the given cpunum,
  // which happens to be that cpu's APIC ID.
  ioapicwrite(REG_TABLE+2*irq, T_IRQ0 + irq);
  ioapicwrite(REG_TABLE+2*irq+1, cpunum << 24);
}
801022d1:	5d                   	pop    %ebp
801022d2:	c3                   	ret    
801022d3:	66 90                	xchg   %ax,%ax
801022d5:	66 90                	xchg   %ax,%ax
801022d7:	66 90                	xchg   %ax,%ax
801022d9:	66 90                	xchg   %ax,%ax
801022db:	66 90                	xchg   %ax,%ax
801022dd:	66 90                	xchg   %ax,%ax
801022df:	90                   	nop

801022e0 <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(char *v)
{
801022e0:	55                   	push   %ebp
801022e1:	89 e5                	mov    %esp,%ebp
801022e3:	53                   	push   %ebx
801022e4:	83 ec 04             	sub    $0x4,%esp
801022e7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
801022ea:	f7 c3 ff 0f 00 00    	test   $0xfff,%ebx
801022f0:	75 70                	jne    80102362 <kfree+0x82>
801022f2:	81 fb 08 57 11 80    	cmp    $0x80115708,%ebx
801022f8:	72 68                	jb     80102362 <kfree+0x82>
801022fa:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80102300:	3d ff ff ff 0d       	cmp    $0xdffffff,%eax
80102305:	77 5b                	ja     80102362 <kfree+0x82>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);
80102307:	83 ec 04             	sub    $0x4,%esp
8010230a:	68 00 10 00 00       	push   $0x1000
8010230f:	6a 01                	push   $0x1
80102311:	53                   	push   %ebx
80102312:	e8 39 21 00 00       	call   80104450 <memset>

  if(kmem.use_lock)
80102317:	8b 15 d4 26 11 80    	mov    0x801126d4,%edx
8010231d:	83 c4 10             	add    $0x10,%esp
80102320:	85 d2                	test   %edx,%edx
80102322:	75 2c                	jne    80102350 <kfree+0x70>
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
80102324:	a1 d8 26 11 80       	mov    0x801126d8,%eax
80102329:	89 03                	mov    %eax,(%ebx)
  kmem.freelist = r;
  if(kmem.use_lock)
8010232b:	a1 d4 26 11 80       	mov    0x801126d4,%eax

  if(kmem.use_lock)
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
80102330:	89 1d d8 26 11 80    	mov    %ebx,0x801126d8
  if(kmem.use_lock)
80102336:	85 c0                	test   %eax,%eax
80102338:	75 06                	jne    80102340 <kfree+0x60>
    release(&kmem.lock);
}
8010233a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010233d:	c9                   	leave  
8010233e:	c3                   	ret    
8010233f:	90                   	nop
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
80102340:	c7 45 08 a0 26 11 80 	movl   $0x801126a0,0x8(%ebp)
}
80102347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010234a:	c9                   	leave  
    acquire(&kmem.lock);
  r = (struct run*)v;
  r->next = kmem.freelist;
  kmem.freelist = r;
  if(kmem.use_lock)
    release(&kmem.lock);
8010234b:	e9 b0 20 00 00       	jmp    80104400 <release>

  // Fill with junk to catch dangling refs.
  memset(v, 1, PGSIZE);

  if(kmem.use_lock)
    acquire(&kmem.lock);
80102350:	83 ec 0c             	sub    $0xc,%esp
80102353:	68 a0 26 11 80       	push   $0x801126a0
80102358:	e8 f3 1f 00 00       	call   80104350 <acquire>
8010235d:	83 c4 10             	add    $0x10,%esp
80102360:	eb c2                	jmp    80102324 <kfree+0x44>
kfree(char *v)
{
  struct run *r;

  if((uint)v % PGSIZE || v < end || V2P(v) >= PHYSTOP)
    panic("kfree");
80102362:	83 ec 0c             	sub    $0xc,%esp
80102365:	68 c6 72 10 80       	push   $0x801072c6
8010236a:	e8 01 e0 ff ff       	call   80100370 <panic>
8010236f:	90                   	nop

80102370 <freerange>:
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102370:	55                   	push   %ebp
80102371:	89 e5                	mov    %esp,%ebp
80102373:	56                   	push   %esi
80102374:	53                   	push   %ebx
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102375:	8b 45 08             	mov    0x8(%ebp),%eax
  kmem.use_lock = 1;
}

void
freerange(void *vstart, void *vend)
{
80102378:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010237b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102381:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102387:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010238d:	39 de                	cmp    %ebx,%esi
8010238f:	72 23                	jb     801023b4 <freerange+0x44>
80102391:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102398:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010239e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023a1:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
801023a7:	50                   	push   %eax
801023a8:	e8 33 ff ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023ad:	83 c4 10             	add    $0x10,%esp
801023b0:	39 f3                	cmp    %esi,%ebx
801023b2:	76 e4                	jbe    80102398 <freerange+0x28>
    kfree(p);
}
801023b4:	8d 65 f8             	lea    -0x8(%ebp),%esp
801023b7:	5b                   	pop    %ebx
801023b8:	5e                   	pop    %esi
801023b9:	5d                   	pop    %ebp
801023ba:	c3                   	ret    
801023bb:	90                   	nop
801023bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801023c0 <kinit1>:
// the pages mapped by entrypgdir on free list.
// 2. main() calls kinit2() with the rest of the physical pages
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
801023c0:	55                   	push   %ebp
801023c1:	89 e5                	mov    %esp,%ebp
801023c3:	56                   	push   %esi
801023c4:	53                   	push   %ebx
801023c5:	8b 75 0c             	mov    0xc(%ebp),%esi
  initlock(&kmem.lock, "kmem");
801023c8:	83 ec 08             	sub    $0x8,%esp
801023cb:	68 cc 72 10 80       	push   $0x801072cc
801023d0:	68 a0 26 11 80       	push   $0x801126a0
801023d5:	e8 16 1e 00 00       	call   801041f0 <initlock>

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023da:	8b 45 08             	mov    0x8(%ebp),%eax
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023dd:	83 c4 10             	add    $0x10,%esp
// after installing a full page table that maps them on all cores.
void
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
801023e0:	c7 05 d4 26 11 80 00 	movl   $0x0,0x801126d4
801023e7:	00 00 00 

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
801023ea:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
801023f0:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
801023f6:	81 c3 00 10 00 00    	add    $0x1000,%ebx
801023fc:	39 de                	cmp    %ebx,%esi
801023fe:	72 1c                	jb     8010241c <kinit1+0x5c>
    kfree(p);
80102400:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
80102406:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102409:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
8010240f:	50                   	push   %eax
80102410:	e8 cb fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102415:	83 c4 10             	add    $0x10,%esp
80102418:	39 de                	cmp    %ebx,%esi
8010241a:	73 e4                	jae    80102400 <kinit1+0x40>
kinit1(void *vstart, void *vend)
{
  initlock(&kmem.lock, "kmem");
  kmem.use_lock = 0;
  freerange(vstart, vend);
}
8010241c:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010241f:	5b                   	pop    %ebx
80102420:	5e                   	pop    %esi
80102421:	5d                   	pop    %ebp
80102422:	c3                   	ret    
80102423:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102429:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102430 <kinit2>:

void
kinit2(void *vstart, void *vend)
{
80102430:	55                   	push   %ebp
80102431:	89 e5                	mov    %esp,%ebp
80102433:	56                   	push   %esi
80102434:	53                   	push   %ebx

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
80102435:	8b 45 08             	mov    0x8(%ebp),%eax
  freerange(vstart, vend);
}

void
kinit2(void *vstart, void *vend)
{
80102438:	8b 75 0c             	mov    0xc(%ebp),%esi

void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
8010243b:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80102441:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102447:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010244d:	39 de                	cmp    %ebx,%esi
8010244f:	72 23                	jb     80102474 <kinit2+0x44>
80102451:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    kfree(p);
80102458:	8d 83 00 f0 ff ff    	lea    -0x1000(%ebx),%eax
8010245e:	83 ec 0c             	sub    $0xc,%esp
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
80102461:	81 c3 00 10 00 00    	add    $0x1000,%ebx
    kfree(p);
80102467:	50                   	push   %eax
80102468:	e8 73 fe ff ff       	call   801022e0 <kfree>
void
freerange(void *vstart, void *vend)
{
  char *p;
  p = (char*)PGROUNDUP((uint)vstart);
  for(; p + PGSIZE <= (char*)vend; p += PGSIZE)
8010246d:	83 c4 10             	add    $0x10,%esp
80102470:	39 de                	cmp    %ebx,%esi
80102472:	73 e4                	jae    80102458 <kinit2+0x28>

void
kinit2(void *vstart, void *vend)
{
  freerange(vstart, vend);
  kmem.use_lock = 1;
80102474:	c7 05 d4 26 11 80 01 	movl   $0x1,0x801126d4
8010247b:	00 00 00 
}
8010247e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80102481:	5b                   	pop    %ebx
80102482:	5e                   	pop    %esi
80102483:	5d                   	pop    %ebp
80102484:	c3                   	ret    
80102485:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102489:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102490 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
char*
kalloc(void)
{
80102490:	55                   	push   %ebp
80102491:	89 e5                	mov    %esp,%ebp
80102493:	53                   	push   %ebx
80102494:	83 ec 04             	sub    $0x4,%esp
  struct run *r;

  if(kmem.use_lock)
80102497:	a1 d4 26 11 80       	mov    0x801126d4,%eax
8010249c:	85 c0                	test   %eax,%eax
8010249e:	75 30                	jne    801024d0 <kalloc+0x40>
    acquire(&kmem.lock);
  r = kmem.freelist;
801024a0:	8b 1d d8 26 11 80    	mov    0x801126d8,%ebx
  if(r)
801024a6:	85 db                	test   %ebx,%ebx
801024a8:	74 1c                	je     801024c6 <kalloc+0x36>
    kmem.freelist = r->next;
801024aa:	8b 13                	mov    (%ebx),%edx
801024ac:	89 15 d8 26 11 80    	mov    %edx,0x801126d8
  if(kmem.use_lock)
801024b2:	85 c0                	test   %eax,%eax
801024b4:	74 10                	je     801024c6 <kalloc+0x36>
    release(&kmem.lock);
801024b6:	83 ec 0c             	sub    $0xc,%esp
801024b9:	68 a0 26 11 80       	push   $0x801126a0
801024be:	e8 3d 1f 00 00       	call   80104400 <release>
801024c3:	83 c4 10             	add    $0x10,%esp
  return (char*)r;
}
801024c6:	89 d8                	mov    %ebx,%eax
801024c8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801024cb:	c9                   	leave  
801024cc:	c3                   	ret    
801024cd:	8d 76 00             	lea    0x0(%esi),%esi
kalloc(void)
{
  struct run *r;

  if(kmem.use_lock)
    acquire(&kmem.lock);
801024d0:	83 ec 0c             	sub    $0xc,%esp
801024d3:	68 a0 26 11 80       	push   $0x801126a0
801024d8:	e8 73 1e 00 00       	call   80104350 <acquire>
  r = kmem.freelist;
801024dd:	8b 1d d8 26 11 80    	mov    0x801126d8,%ebx
  if(r)
801024e3:	83 c4 10             	add    $0x10,%esp
801024e6:	a1 d4 26 11 80       	mov    0x801126d4,%eax
801024eb:	85 db                	test   %ebx,%ebx
801024ed:	75 bb                	jne    801024aa <kalloc+0x1a>
801024ef:	eb c1                	jmp    801024b2 <kalloc+0x22>
801024f1:	66 90                	xchg   %ax,%ax
801024f3:	66 90                	xchg   %ax,%ax
801024f5:	66 90                	xchg   %ax,%ax
801024f7:	66 90                	xchg   %ax,%ax
801024f9:	66 90                	xchg   %ax,%ax
801024fb:	66 90                	xchg   %ax,%ax
801024fd:	66 90                	xchg   %ax,%ax
801024ff:	90                   	nop

80102500 <kbdgetc>:
#include "defs.h"
#include "kbd.h"

int
kbdgetc(void)
{
80102500:	55                   	push   %ebp
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102501:	ba 64 00 00 00       	mov    $0x64,%edx
80102506:	89 e5                	mov    %esp,%ebp
80102508:	ec                   	in     (%dx),%al
    normalmap, shiftmap, ctlmap, ctlmap
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
80102509:	a8 01                	test   $0x1,%al
8010250b:	0f 84 af 00 00 00    	je     801025c0 <kbdgetc+0xc0>
80102511:	ba 60 00 00 00       	mov    $0x60,%edx
80102516:	ec                   	in     (%dx),%al
    return -1;
  data = inb(KBDATAP);
80102517:	0f b6 d0             	movzbl %al,%edx

  if(data == 0xE0){
8010251a:	81 fa e0 00 00 00    	cmp    $0xe0,%edx
80102520:	74 7e                	je     801025a0 <kbdgetc+0xa0>
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
80102522:	84 c0                	test   %al,%al
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
80102524:	8b 0d 14 a6 10 80    	mov    0x8010a614,%ecx
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
  } else if(data & 0x80){
8010252a:	79 24                	jns    80102550 <kbdgetc+0x50>
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
8010252c:	f6 c1 40             	test   $0x40,%cl
8010252f:	75 05                	jne    80102536 <kbdgetc+0x36>
80102531:	89 c2                	mov    %eax,%edx
80102533:	83 e2 7f             	and    $0x7f,%edx
    shift &= ~(shiftcode[data] | E0ESC);
80102536:	0f b6 82 00 74 10 80 	movzbl -0x7fef8c00(%edx),%eax
8010253d:	83 c8 40             	or     $0x40,%eax
80102540:	0f b6 c0             	movzbl %al,%eax
80102543:	f7 d0                	not    %eax
80102545:	21 c8                	and    %ecx,%eax
80102547:	a3 14 a6 10 80       	mov    %eax,0x8010a614
    return 0;
8010254c:	31 c0                	xor    %eax,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
8010254e:	5d                   	pop    %ebp
8010254f:	c3                   	ret    
  } else if(data & 0x80){
    // Key released
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
80102550:	f6 c1 40             	test   $0x40,%cl
80102553:	74 09                	je     8010255e <kbdgetc+0x5e>
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
80102555:	83 c8 80             	or     $0xffffff80,%eax
    shift &= ~E0ESC;
80102558:	83 e1 bf             	and    $0xffffffbf,%ecx
    data = (shift & E0ESC ? data : data & 0x7F);
    shift &= ~(shiftcode[data] | E0ESC);
    return 0;
  } else if(shift & E0ESC){
    // Last character was an E0 escape; or with 0x80
    data |= 0x80;
8010255b:	0f b6 d0             	movzbl %al,%edx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
8010255e:	0f b6 82 00 74 10 80 	movzbl -0x7fef8c00(%edx),%eax
80102565:	09 c1                	or     %eax,%ecx
80102567:	0f b6 82 00 73 10 80 	movzbl -0x7fef8d00(%edx),%eax
8010256e:	31 c1                	xor    %eax,%ecx
  c = charcode[shift & (CTL | SHIFT)][data];
80102570:	89 c8                	mov    %ecx,%eax
    data |= 0x80;
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
80102572:	89 0d 14 a6 10 80    	mov    %ecx,0x8010a614
  c = charcode[shift & (CTL | SHIFT)][data];
80102578:	83 e0 03             	and    $0x3,%eax
  if(shift & CAPSLOCK){
8010257b:	83 e1 08             	and    $0x8,%ecx
    shift &= ~E0ESC;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
8010257e:	8b 04 85 e0 72 10 80 	mov    -0x7fef8d20(,%eax,4),%eax
80102585:	0f b6 04 10          	movzbl (%eax,%edx,1),%eax
  if(shift & CAPSLOCK){
80102589:	74 c3                	je     8010254e <kbdgetc+0x4e>
    if('a' <= c && c <= 'z')
8010258b:	8d 50 9f             	lea    -0x61(%eax),%edx
8010258e:	83 fa 19             	cmp    $0x19,%edx
80102591:	77 1d                	ja     801025b0 <kbdgetc+0xb0>
      c += 'A' - 'a';
80102593:	83 e8 20             	sub    $0x20,%eax
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
80102596:	5d                   	pop    %ebp
80102597:	c3                   	ret    
80102598:	90                   	nop
80102599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
    return 0;
801025a0:	31 c0                	xor    %eax,%eax
  if((st & KBS_DIB) == 0)
    return -1;
  data = inb(KBDATAP);

  if(data == 0xE0){
    shift |= E0ESC;
801025a2:	83 0d 14 a6 10 80 40 	orl    $0x40,0x8010a614
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025a9:	5d                   	pop    %ebp
801025aa:	c3                   	ret    
801025ab:	90                   	nop
801025ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  shift ^= togglecode[data];
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
801025b0:	8d 48 bf             	lea    -0x41(%eax),%ecx
      c += 'a' - 'A';
801025b3:	8d 50 20             	lea    0x20(%eax),%edx
  }
  return c;
}
801025b6:	5d                   	pop    %ebp
  c = charcode[shift & (CTL | SHIFT)][data];
  if(shift & CAPSLOCK){
    if('a' <= c && c <= 'z')
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
801025b7:	83 f9 19             	cmp    $0x19,%ecx
801025ba:	0f 46 c2             	cmovbe %edx,%eax
  }
  return c;
}
801025bd:	c3                   	ret    
801025be:	66 90                	xchg   %ax,%ax
  };
  uint st, data, c;

  st = inb(KBSTATP);
  if((st & KBS_DIB) == 0)
    return -1;
801025c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      c += 'A' - 'a';
    else if('A' <= c && c <= 'Z')
      c += 'a' - 'A';
  }
  return c;
}
801025c5:	5d                   	pop    %ebp
801025c6:	c3                   	ret    
801025c7:	89 f6                	mov    %esi,%esi
801025c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801025d0 <kbdintr>:

void
kbdintr(void)
{
801025d0:	55                   	push   %ebp
801025d1:	89 e5                	mov    %esp,%ebp
801025d3:	83 ec 14             	sub    $0x14,%esp
  consoleintr(kbdgetc);
801025d6:	68 00 25 10 80       	push   $0x80102500
801025db:	e8 10 e2 ff ff       	call   801007f0 <consoleintr>
}
801025e0:	83 c4 10             	add    $0x10,%esp
801025e3:	c9                   	leave  
801025e4:	c3                   	ret    
801025e5:	66 90                	xchg   %ax,%ax
801025e7:	66 90                	xchg   %ax,%ax
801025e9:	66 90                	xchg   %ax,%ax
801025eb:	66 90                	xchg   %ax,%ax
801025ed:	66 90                	xchg   %ax,%ax
801025ef:	90                   	nop

801025f0 <lapicinit>:
}

void
lapicinit(void)
{
  if(!lapic)
801025f0:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  lapic[ID];  // wait for write to finish, by reading
}

void
lapicinit(void)
{
801025f5:	55                   	push   %ebp
801025f6:	89 e5                	mov    %esp,%ebp
  if(!lapic)
801025f8:	85 c0                	test   %eax,%eax
801025fa:	0f 84 c8 00 00 00    	je     801026c8 <lapicinit+0xd8>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102600:	c7 80 f0 00 00 00 3f 	movl   $0x13f,0xf0(%eax)
80102607:	01 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010260a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010260d:	c7 80 e0 03 00 00 0b 	movl   $0xb,0x3e0(%eax)
80102614:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102617:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010261a:	c7 80 20 03 00 00 20 	movl   $0x20020,0x320(%eax)
80102621:	00 02 00 
  lapic[ID];  // wait for write to finish, by reading
80102624:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102627:	c7 80 80 03 00 00 80 	movl   $0x989680,0x380(%eax)
8010262e:	96 98 00 
  lapic[ID];  // wait for write to finish, by reading
80102631:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102634:	c7 80 50 03 00 00 00 	movl   $0x10000,0x350(%eax)
8010263b:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010263e:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102641:	c7 80 60 03 00 00 00 	movl   $0x10000,0x360(%eax)
80102648:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
8010264b:	8b 50 20             	mov    0x20(%eax),%edx
  lapicw(LINT0, MASKED);
  lapicw(LINT1, MASKED);

  // Disable performance counter overflow interrupts
  // on machines that provide that interrupt entry.
  if(((lapic[VER]>>16) & 0xFF) >= 4)
8010264e:	8b 50 30             	mov    0x30(%eax),%edx
80102651:	c1 ea 10             	shr    $0x10,%edx
80102654:	80 fa 03             	cmp    $0x3,%dl
80102657:	77 77                	ja     801026d0 <lapicinit+0xe0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102659:	c7 80 70 03 00 00 33 	movl   $0x33,0x370(%eax)
80102660:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102663:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102666:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010266d:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102670:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102673:	c7 80 80 02 00 00 00 	movl   $0x0,0x280(%eax)
8010267a:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010267d:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102680:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102687:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
8010268a:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010268d:	c7 80 10 03 00 00 00 	movl   $0x0,0x310(%eax)
80102694:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102697:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010269a:	c7 80 00 03 00 00 00 	movl   $0x88500,0x300(%eax)
801026a1:	85 08 00 
  lapic[ID];  // wait for write to finish, by reading
801026a4:	8b 50 20             	mov    0x20(%eax),%edx
801026a7:	89 f6                	mov    %esi,%esi
801026a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  lapicw(EOI, 0);

  // Send an Init Level De-Assert to synchronise arbitration ID's.
  lapicw(ICRHI, 0);
  lapicw(ICRLO, BCAST | INIT | LEVEL);
  while(lapic[ICRLO] & DELIVS)
801026b0:	8b 90 00 03 00 00    	mov    0x300(%eax),%edx
801026b6:	80 e6 10             	and    $0x10,%dh
801026b9:	75 f5                	jne    801026b0 <lapicinit+0xc0>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026bb:	c7 80 80 00 00 00 00 	movl   $0x0,0x80(%eax)
801026c2:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
801026c5:	8b 40 20             	mov    0x20(%eax),%eax
  while(lapic[ICRLO] & DELIVS)
    ;

  // Enable interrupts on the APIC (but not on the processor).
  lapicw(TPR, 0);
}
801026c8:	5d                   	pop    %ebp
801026c9:	c3                   	ret    
801026ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801026d0:	c7 80 40 03 00 00 00 	movl   $0x10000,0x340(%eax)
801026d7:	00 01 00 
  lapic[ID];  // wait for write to finish, by reading
801026da:	8b 50 20             	mov    0x20(%eax),%edx
801026dd:	e9 77 ff ff ff       	jmp    80102659 <lapicinit+0x69>
801026e2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801026e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801026f0 <lapicid>:
}

int
lapicid(void)
{
  if (!lapic)
801026f0:	a1 dc 26 11 80       	mov    0x801126dc,%eax
  lapicw(TPR, 0);
}

int
lapicid(void)
{
801026f5:	55                   	push   %ebp
801026f6:	89 e5                	mov    %esp,%ebp
  if (!lapic)
801026f8:	85 c0                	test   %eax,%eax
801026fa:	74 0c                	je     80102708 <lapicid+0x18>
    return 0;
  return lapic[ID] >> 24;
801026fc:	8b 40 20             	mov    0x20(%eax),%eax
}
801026ff:	5d                   	pop    %ebp
int
lapicid(void)
{
  if (!lapic)
    return 0;
  return lapic[ID] >> 24;
80102700:	c1 e8 18             	shr    $0x18,%eax
}
80102703:	c3                   	ret    
80102704:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

int
lapicid(void)
{
  if (!lapic)
    return 0;
80102708:	31 c0                	xor    %eax,%eax
  return lapic[ID] >> 24;
}
8010270a:	5d                   	pop    %ebp
8010270b:	c3                   	ret    
8010270c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102710 <lapiceoi>:

// Acknowledge interrupt.
void
lapiceoi(void)
{
  if(lapic)
80102710:	a1 dc 26 11 80       	mov    0x801126dc,%eax
}

// Acknowledge interrupt.
void
lapiceoi(void)
{
80102715:	55                   	push   %ebp
80102716:	89 e5                	mov    %esp,%ebp
  if(lapic)
80102718:	85 c0                	test   %eax,%eax
8010271a:	74 0d                	je     80102729 <lapiceoi+0x19>

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010271c:	c7 80 b0 00 00 00 00 	movl   $0x0,0xb0(%eax)
80102723:	00 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102726:	8b 40 20             	mov    0x20(%eax),%eax
void
lapiceoi(void)
{
  if(lapic)
    lapicw(EOI, 0);
}
80102729:	5d                   	pop    %ebp
8010272a:	c3                   	ret    
8010272b:	90                   	nop
8010272c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80102730 <microdelay>:

// Spin for a given number of microseconds.
// On real hardware would want to tune this dynamically.
void
microdelay(int us)
{
80102730:	55                   	push   %ebp
80102731:	89 e5                	mov    %esp,%ebp
}
80102733:	5d                   	pop    %ebp
80102734:	c3                   	ret    
80102735:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102739:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102740 <lapicstartap>:

// Start additional processor running entry code at addr.
// See Appendix B of MultiProcessor Specification.
void
lapicstartap(uchar apicid, uint addr)
{
80102740:	55                   	push   %ebp
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102741:	ba 70 00 00 00       	mov    $0x70,%edx
80102746:	b8 0f 00 00 00       	mov    $0xf,%eax
8010274b:	89 e5                	mov    %esp,%ebp
8010274d:	53                   	push   %ebx
8010274e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80102751:	8b 5d 08             	mov    0x8(%ebp),%ebx
80102754:	ee                   	out    %al,(%dx)
80102755:	ba 71 00 00 00       	mov    $0x71,%edx
8010275a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010275f:	ee                   	out    %al,(%dx)
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102760:	31 c0                	xor    %eax,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102762:	c1 e3 18             	shl    $0x18,%ebx
  // and the warm reset vector (DWORD based at 40:67) to point at
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
80102765:	66 a3 67 04 00 80    	mov    %ax,0x80000467
  wrv[1] = addr >> 4;
8010276b:	89 c8                	mov    %ecx,%eax
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
8010276d:	c1 e9 0c             	shr    $0xc,%ecx
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102770:	c1 e8 04             	shr    $0x4,%eax

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102773:	89 da                	mov    %ebx,%edx
  // when it is in the halted state due to an INIT.  So the second
  // should be ignored, but it is part of the official Intel algorithm.
  // Bochs complains about the second one.  Too bad for Bochs.
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
80102775:	80 cd 06             	or     $0x6,%ch
  // the AP startup code prior to the [universal startup algorithm]."
  outb(CMOS_PORT, 0xF);  // offset 0xF is shutdown code
  outb(CMOS_PORT+1, 0x0A);
  wrv = (ushort*)P2V((0x40<<4 | 0x67));  // Warm reset vector
  wrv[0] = 0;
  wrv[1] = addr >> 4;
80102778:	66 a3 69 04 00 80    	mov    %ax,0x80000469

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010277e:	a1 dc 26 11 80       	mov    0x801126dc,%eax
80102783:	89 98 10 03 00 00    	mov    %ebx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
80102789:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
8010278c:	c7 80 00 03 00 00 00 	movl   $0xc500,0x300(%eax)
80102793:	c5 00 00 
  lapic[ID];  // wait for write to finish, by reading
80102796:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
80102799:	c7 80 00 03 00 00 00 	movl   $0x8500,0x300(%eax)
801027a0:	85 00 00 
  lapic[ID];  // wait for write to finish, by reading
801027a3:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027a6:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027ac:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027af:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027b5:	8b 58 20             	mov    0x20(%eax),%ebx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027b8:	89 90 10 03 00 00    	mov    %edx,0x310(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027be:	8b 50 20             	mov    0x20(%eax),%edx

//PAGEBREAK!
static void
lapicw(int index, int value)
{
  lapic[index] = value;
801027c1:	89 88 00 03 00 00    	mov    %ecx,0x300(%eax)
  lapic[ID];  // wait for write to finish, by reading
801027c7:	8b 40 20             	mov    0x20(%eax),%eax
  for(i = 0; i < 2; i++){
    lapicw(ICRHI, apicid<<24);
    lapicw(ICRLO, STARTUP | (addr>>12));
    microdelay(200);
  }
}
801027ca:	5b                   	pop    %ebx
801027cb:	5d                   	pop    %ebp
801027cc:	c3                   	ret    
801027cd:	8d 76 00             	lea    0x0(%esi),%esi

801027d0 <cmostime>:
}

// qemu seems to use 24-hour GWT and the values are BCD encoded
void
cmostime(struct rtcdate *r)
{
801027d0:	55                   	push   %ebp
801027d1:	ba 70 00 00 00       	mov    $0x70,%edx
801027d6:	b8 0b 00 00 00       	mov    $0xb,%eax
801027db:	89 e5                	mov    %esp,%ebp
801027dd:	57                   	push   %edi
801027de:	56                   	push   %esi
801027df:	53                   	push   %ebx
801027e0:	83 ec 4c             	sub    $0x4c,%esp
801027e3:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801027e4:	ba 71 00 00 00       	mov    $0x71,%edx
801027e9:	ec                   	in     (%dx),%al
801027ea:	83 e0 04             	and    $0x4,%eax
801027ed:	8d 75 d0             	lea    -0x30(%ebp),%esi
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801027f0:	31 db                	xor    %ebx,%ebx
801027f2:	88 45 b7             	mov    %al,-0x49(%ebp)
801027f5:	bf 70 00 00 00       	mov    $0x70,%edi
801027fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102800:	89 d8                	mov    %ebx,%eax
80102802:	89 fa                	mov    %edi,%edx
80102804:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102805:	b9 71 00 00 00       	mov    $0x71,%ecx
8010280a:	89 ca                	mov    %ecx,%edx
8010280c:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010280d:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102810:	89 fa                	mov    %edi,%edx
80102812:	89 45 b8             	mov    %eax,-0x48(%ebp)
80102815:	b8 02 00 00 00       	mov    $0x2,%eax
8010281a:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010281b:	89 ca                	mov    %ecx,%edx
8010281d:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
8010281e:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102821:	89 fa                	mov    %edi,%edx
80102823:	89 45 bc             	mov    %eax,-0x44(%ebp)
80102826:	b8 04 00 00 00       	mov    $0x4,%eax
8010282b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010282c:	89 ca                	mov    %ecx,%edx
8010282e:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
8010282f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102832:	89 fa                	mov    %edi,%edx
80102834:	89 45 c0             	mov    %eax,-0x40(%ebp)
80102837:	b8 07 00 00 00       	mov    $0x7,%eax
8010283c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010283d:	89 ca                	mov    %ecx,%edx
8010283f:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
80102840:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102843:	89 fa                	mov    %edi,%edx
80102845:	89 45 c4             	mov    %eax,-0x3c(%ebp)
80102848:	b8 08 00 00 00       	mov    $0x8,%eax
8010284d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010284e:	89 ca                	mov    %ecx,%edx
80102850:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
80102851:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102854:	89 fa                	mov    %edi,%edx
80102856:	89 45 c8             	mov    %eax,-0x38(%ebp)
80102859:	b8 09 00 00 00       	mov    $0x9,%eax
8010285e:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010285f:	89 ca                	mov    %ecx,%edx
80102861:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
80102862:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102865:	89 fa                	mov    %edi,%edx
80102867:	89 45 cc             	mov    %eax,-0x34(%ebp)
8010286a:	b8 0a 00 00 00       	mov    $0xa,%eax
8010286f:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80102870:	89 ca                	mov    %ecx,%edx
80102872:	ec                   	in     (%dx),%al
  bcd = (sb & (1 << 2)) == 0;

  // make sure CMOS doesn't modify time while we read it
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
80102873:	84 c0                	test   %al,%al
80102875:	78 89                	js     80102800 <cmostime+0x30>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102877:	89 d8                	mov    %ebx,%eax
80102879:	89 fa                	mov    %edi,%edx
8010287b:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010287c:	89 ca                	mov    %ecx,%edx
8010287e:	ec                   	in     (%dx),%al
}

static void
fill_rtcdate(struct rtcdate *r)
{
  r->second = cmos_read(SECS);
8010287f:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102882:	89 fa                	mov    %edi,%edx
80102884:	89 45 d0             	mov    %eax,-0x30(%ebp)
80102887:	b8 02 00 00 00       	mov    $0x2,%eax
8010288c:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010288d:	89 ca                	mov    %ecx,%edx
8010288f:	ec                   	in     (%dx),%al
  r->minute = cmos_read(MINS);
80102890:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80102893:	89 fa                	mov    %edi,%edx
80102895:	89 45 d4             	mov    %eax,-0x2c(%ebp)
80102898:	b8 04 00 00 00       	mov    $0x4,%eax
8010289d:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
8010289e:	89 ca                	mov    %ecx,%edx
801028a0:	ec                   	in     (%dx),%al
  r->hour   = cmos_read(HOURS);
801028a1:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028a4:	89 fa                	mov    %edi,%edx
801028a6:	89 45 d8             	mov    %eax,-0x28(%ebp)
801028a9:	b8 07 00 00 00       	mov    $0x7,%eax
801028ae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028af:	89 ca                	mov    %ecx,%edx
801028b1:	ec                   	in     (%dx),%al
  r->day    = cmos_read(DAY);
801028b2:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028b5:	89 fa                	mov    %edi,%edx
801028b7:	89 45 dc             	mov    %eax,-0x24(%ebp)
801028ba:	b8 08 00 00 00       	mov    $0x8,%eax
801028bf:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028c0:	89 ca                	mov    %ecx,%edx
801028c2:	ec                   	in     (%dx),%al
  r->month  = cmos_read(MONTH);
801028c3:	0f b6 c0             	movzbl %al,%eax
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
801028c6:	89 fa                	mov    %edi,%edx
801028c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
801028cb:	b8 09 00 00 00       	mov    $0x9,%eax
801028d0:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
801028d1:	89 ca                	mov    %ecx,%edx
801028d3:	ec                   	in     (%dx),%al
  r->year   = cmos_read(YEAR);
801028d4:	0f b6 c0             	movzbl %al,%eax
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028d7:	83 ec 04             	sub    $0x4,%esp
  r->second = cmos_read(SECS);
  r->minute = cmos_read(MINS);
  r->hour   = cmos_read(HOURS);
  r->day    = cmos_read(DAY);
  r->month  = cmos_read(MONTH);
  r->year   = cmos_read(YEAR);
801028da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  for(;;) {
    fill_rtcdate(&t1);
    if(cmos_read(CMOS_STATA) & CMOS_UIP)
        continue;
    fill_rtcdate(&t2);
    if(memcmp(&t1, &t2, sizeof(t1)) == 0)
801028dd:	8d 45 b8             	lea    -0x48(%ebp),%eax
801028e0:	6a 18                	push   $0x18
801028e2:	56                   	push   %esi
801028e3:	50                   	push   %eax
801028e4:	e8 b7 1b 00 00       	call   801044a0 <memcmp>
801028e9:	83 c4 10             	add    $0x10,%esp
801028ec:	85 c0                	test   %eax,%eax
801028ee:	0f 85 0c ff ff ff    	jne    80102800 <cmostime+0x30>
      break;
  }

  // convert
  if(bcd) {
801028f4:	80 7d b7 00          	cmpb   $0x0,-0x49(%ebp)
801028f8:	75 78                	jne    80102972 <cmostime+0x1a2>
#define    CONV(x)     (t1.x = ((t1.x >> 4) * 10) + (t1.x & 0xf))
    CONV(second);
801028fa:	8b 45 b8             	mov    -0x48(%ebp),%eax
801028fd:	89 c2                	mov    %eax,%edx
801028ff:	83 e0 0f             	and    $0xf,%eax
80102902:	c1 ea 04             	shr    $0x4,%edx
80102905:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102908:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010290b:	89 45 b8             	mov    %eax,-0x48(%ebp)
    CONV(minute);
8010290e:	8b 45 bc             	mov    -0x44(%ebp),%eax
80102911:	89 c2                	mov    %eax,%edx
80102913:	83 e0 0f             	and    $0xf,%eax
80102916:	c1 ea 04             	shr    $0x4,%edx
80102919:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010291c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010291f:	89 45 bc             	mov    %eax,-0x44(%ebp)
    CONV(hour  );
80102922:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102925:	89 c2                	mov    %eax,%edx
80102927:	83 e0 0f             	and    $0xf,%eax
8010292a:	c1 ea 04             	shr    $0x4,%edx
8010292d:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102930:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102933:	89 45 c0             	mov    %eax,-0x40(%ebp)
    CONV(day   );
80102936:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102939:	89 c2                	mov    %eax,%edx
8010293b:	83 e0 0f             	and    $0xf,%eax
8010293e:	c1 ea 04             	shr    $0x4,%edx
80102941:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102944:	8d 04 50             	lea    (%eax,%edx,2),%eax
80102947:	89 45 c4             	mov    %eax,-0x3c(%ebp)
    CONV(month );
8010294a:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010294d:	89 c2                	mov    %eax,%edx
8010294f:	83 e0 0f             	and    $0xf,%eax
80102952:	c1 ea 04             	shr    $0x4,%edx
80102955:	8d 14 92             	lea    (%edx,%edx,4),%edx
80102958:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010295b:	89 45 c8             	mov    %eax,-0x38(%ebp)
    CONV(year  );
8010295e:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102961:	89 c2                	mov    %eax,%edx
80102963:	83 e0 0f             	and    $0xf,%eax
80102966:	c1 ea 04             	shr    $0x4,%edx
80102969:	8d 14 92             	lea    (%edx,%edx,4),%edx
8010296c:	8d 04 50             	lea    (%eax,%edx,2),%eax
8010296f:	89 45 cc             	mov    %eax,-0x34(%ebp)
#undef     CONV
  }

  *r = t1;
80102972:	8b 75 08             	mov    0x8(%ebp),%esi
80102975:	8b 45 b8             	mov    -0x48(%ebp),%eax
80102978:	89 06                	mov    %eax,(%esi)
8010297a:	8b 45 bc             	mov    -0x44(%ebp),%eax
8010297d:	89 46 04             	mov    %eax,0x4(%esi)
80102980:	8b 45 c0             	mov    -0x40(%ebp),%eax
80102983:	89 46 08             	mov    %eax,0x8(%esi)
80102986:	8b 45 c4             	mov    -0x3c(%ebp),%eax
80102989:	89 46 0c             	mov    %eax,0xc(%esi)
8010298c:	8b 45 c8             	mov    -0x38(%ebp),%eax
8010298f:	89 46 10             	mov    %eax,0x10(%esi)
80102992:	8b 45 cc             	mov    -0x34(%ebp),%eax
80102995:	89 46 14             	mov    %eax,0x14(%esi)
  r->year += 2000;
80102998:	81 46 14 d0 07 00 00 	addl   $0x7d0,0x14(%esi)
}
8010299f:	8d 65 f4             	lea    -0xc(%ebp),%esp
801029a2:	5b                   	pop    %ebx
801029a3:	5e                   	pop    %esi
801029a4:	5f                   	pop    %edi
801029a5:	5d                   	pop    %ebp
801029a6:	c3                   	ret    
801029a7:	66 90                	xchg   %ax,%ax
801029a9:	66 90                	xchg   %ax,%ax
801029ab:	66 90                	xchg   %ax,%ax
801029ad:	66 90                	xchg   %ax,%ax
801029af:	90                   	nop

801029b0 <install_trans>:
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029b0:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
801029b6:	85 c9                	test   %ecx,%ecx
801029b8:	0f 8e 85 00 00 00    	jle    80102a43 <install_trans+0x93>
}

// Copy committed blocks from log to their home location
static void
install_trans(void)
{
801029be:	55                   	push   %ebp
801029bf:	89 e5                	mov    %esp,%ebp
801029c1:	57                   	push   %edi
801029c2:	56                   	push   %esi
801029c3:	53                   	push   %ebx
801029c4:	31 db                	xor    %ebx,%ebx
801029c6:	83 ec 0c             	sub    $0xc,%esp
801029c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
801029d0:	a1 14 27 11 80       	mov    0x80112714,%eax
801029d5:	83 ec 08             	sub    $0x8,%esp
801029d8:	01 d8                	add    %ebx,%eax
801029da:	83 c0 01             	add    $0x1,%eax
801029dd:	50                   	push   %eax
801029de:	ff 35 24 27 11 80    	pushl  0x80112724
801029e4:	e8 e7 d6 ff ff       	call   801000d0 <bread>
801029e9:	89 c7                	mov    %eax,%edi
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029eb:	58                   	pop    %eax
801029ec:	5a                   	pop    %edx
801029ed:	ff 34 9d 2c 27 11 80 	pushl  -0x7feed8d4(,%ebx,4)
801029f4:	ff 35 24 27 11 80    	pushl  0x80112724
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
801029fa:	83 c3 01             	add    $0x1,%ebx
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
801029fd:	e8 ce d6 ff ff       	call   801000d0 <bread>
80102a02:	89 c6                	mov    %eax,%esi
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
80102a04:	8d 47 5c             	lea    0x5c(%edi),%eax
80102a07:	83 c4 0c             	add    $0xc,%esp
80102a0a:	68 00 02 00 00       	push   $0x200
80102a0f:	50                   	push   %eax
80102a10:	8d 46 5c             	lea    0x5c(%esi),%eax
80102a13:	50                   	push   %eax
80102a14:	e8 e7 1a 00 00       	call   80104500 <memmove>
    bwrite(dbuf);  // write dst to disk
80102a19:	89 34 24             	mov    %esi,(%esp)
80102a1c:	e8 7f d7 ff ff       	call   801001a0 <bwrite>
    brelse(lbuf);
80102a21:	89 3c 24             	mov    %edi,(%esp)
80102a24:	e8 b7 d7 ff ff       	call   801001e0 <brelse>
    brelse(dbuf);
80102a29:	89 34 24             	mov    %esi,(%esp)
80102a2c:	e8 af d7 ff ff       	call   801001e0 <brelse>
static void
install_trans(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102a31:	83 c4 10             	add    $0x10,%esp
80102a34:	39 1d 28 27 11 80    	cmp    %ebx,0x80112728
80102a3a:	7f 94                	jg     801029d0 <install_trans+0x20>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    bwrite(dbuf);  // write dst to disk
    brelse(lbuf);
    brelse(dbuf);
  }
}
80102a3c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102a3f:	5b                   	pop    %ebx
80102a40:	5e                   	pop    %esi
80102a41:	5f                   	pop    %edi
80102a42:	5d                   	pop    %ebp
80102a43:	f3 c3                	repz ret 
80102a45:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80102a49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102a50 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
80102a50:	55                   	push   %ebp
80102a51:	89 e5                	mov    %esp,%ebp
80102a53:	53                   	push   %ebx
80102a54:	83 ec 0c             	sub    $0xc,%esp
  struct buf *buf = bread(log.dev, log.start);
80102a57:	ff 35 14 27 11 80    	pushl  0x80112714
80102a5d:	ff 35 24 27 11 80    	pushl  0x80112724
80102a63:	e8 68 d6 ff ff       	call   801000d0 <bread>
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a68:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
  for (i = 0; i < log.lh.n; i++) {
80102a6e:	83 c4 10             	add    $0x10,%esp
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102a71:	89 c3                	mov    %eax,%ebx
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a73:	85 c9                	test   %ecx,%ecx
write_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
80102a75:	89 48 5c             	mov    %ecx,0x5c(%eax)
  for (i = 0; i < log.lh.n; i++) {
80102a78:	7e 1f                	jle    80102a99 <write_head+0x49>
80102a7a:	8d 04 8d 00 00 00 00 	lea    0x0(,%ecx,4),%eax
80102a81:	31 d2                	xor    %edx,%edx
80102a83:	90                   	nop
80102a84:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    hb->block[i] = log.lh.block[i];
80102a88:	8b 8a 2c 27 11 80    	mov    -0x7feed8d4(%edx),%ecx
80102a8e:	89 4c 13 60          	mov    %ecx,0x60(%ebx,%edx,1)
80102a92:	83 c2 04             	add    $0x4,%edx
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
  for (i = 0; i < log.lh.n; i++) {
80102a95:	39 c2                	cmp    %eax,%edx
80102a97:	75 ef                	jne    80102a88 <write_head+0x38>
    hb->block[i] = log.lh.block[i];
  }
  bwrite(buf);
80102a99:	83 ec 0c             	sub    $0xc,%esp
80102a9c:	53                   	push   %ebx
80102a9d:	e8 fe d6 ff ff       	call   801001a0 <bwrite>
  brelse(buf);
80102aa2:	89 1c 24             	mov    %ebx,(%esp)
80102aa5:	e8 36 d7 ff ff       	call   801001e0 <brelse>
}
80102aaa:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102aad:	c9                   	leave  
80102aae:	c3                   	ret    
80102aaf:	90                   	nop

80102ab0 <initlog>:
static void recover_from_log(void);
static void commit();

void
initlog(int dev)
{
80102ab0:	55                   	push   %ebp
80102ab1:	89 e5                	mov    %esp,%ebp
80102ab3:	53                   	push   %ebx
80102ab4:	83 ec 2c             	sub    $0x2c,%esp
80102ab7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if (sizeof(struct logheader) >= BSIZE)
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
80102aba:	68 00 75 10 80       	push   $0x80107500
80102abf:	68 e0 26 11 80       	push   $0x801126e0
80102ac4:	e8 27 17 00 00       	call   801041f0 <initlock>
  readsb(dev, &sb);
80102ac9:	58                   	pop    %eax
80102aca:	8d 45 dc             	lea    -0x24(%ebp),%eax
80102acd:	5a                   	pop    %edx
80102ace:	50                   	push   %eax
80102acf:	53                   	push   %ebx
80102ad0:	e8 db e8 ff ff       	call   801013b0 <readsb>
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ad5:	8b 55 e8             	mov    -0x18(%ebp),%edx
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ad8:	8b 45 ec             	mov    -0x14(%ebp),%eax

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102adb:	59                   	pop    %ecx
  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
80102adc:	89 1d 24 27 11 80    	mov    %ebx,0x80112724

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
80102ae2:	89 15 18 27 11 80    	mov    %edx,0x80112718
    panic("initlog: too big logheader");

  struct superblock sb;
  initlock(&log.lock, "log");
  readsb(dev, &sb);
  log.start = sb.logstart;
80102ae8:	a3 14 27 11 80       	mov    %eax,0x80112714

// Read the log header from disk into the in-memory log header
static void
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
80102aed:	5a                   	pop    %edx
80102aee:	50                   	push   %eax
80102aef:	53                   	push   %ebx
80102af0:	e8 db d5 ff ff       	call   801000d0 <bread>
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102af5:	8b 48 5c             	mov    0x5c(%eax),%ecx
  for (i = 0; i < log.lh.n; i++) {
80102af8:	83 c4 10             	add    $0x10,%esp
80102afb:	85 c9                	test   %ecx,%ecx
read_head(void)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
80102afd:	89 0d 28 27 11 80    	mov    %ecx,0x80112728
  for (i = 0; i < log.lh.n; i++) {
80102b03:	7e 1c                	jle    80102b21 <initlog+0x71>
80102b05:	8d 1c 8d 00 00 00 00 	lea    0x0(,%ecx,4),%ebx
80102b0c:	31 d2                	xor    %edx,%edx
80102b0e:	66 90                	xchg   %ax,%ax
    log.lh.block[i] = lh->block[i];
80102b10:	8b 4c 10 60          	mov    0x60(%eax,%edx,1),%ecx
80102b14:	83 c2 04             	add    $0x4,%edx
80102b17:	89 8a 28 27 11 80    	mov    %ecx,-0x7feed8d8(%edx)
{
  struct buf *buf = bread(log.dev, log.start);
  struct logheader *lh = (struct logheader *) (buf->data);
  int i;
  log.lh.n = lh->n;
  for (i = 0; i < log.lh.n; i++) {
80102b1d:	39 da                	cmp    %ebx,%edx
80102b1f:	75 ef                	jne    80102b10 <initlog+0x60>
    log.lh.block[i] = lh->block[i];
  }
  brelse(buf);
80102b21:	83 ec 0c             	sub    $0xc,%esp
80102b24:	50                   	push   %eax
80102b25:	e8 b6 d6 ff ff       	call   801001e0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(); // if committed, copy from log to disk
80102b2a:	e8 81 fe ff ff       	call   801029b0 <install_trans>
  log.lh.n = 0;
80102b2f:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
80102b36:	00 00 00 
  write_head(); // clear the log
80102b39:	e8 12 ff ff ff       	call   80102a50 <write_head>
  readsb(dev, &sb);
  log.start = sb.logstart;
  log.size = sb.nlog;
  log.dev = dev;
  recover_from_log();
}
80102b3e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102b41:	c9                   	leave  
80102b42:	c3                   	ret    
80102b43:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80102b49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102b50 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
80102b50:	55                   	push   %ebp
80102b51:	89 e5                	mov    %esp,%ebp
80102b53:	83 ec 14             	sub    $0x14,%esp
  acquire(&log.lock);
80102b56:	68 e0 26 11 80       	push   $0x801126e0
80102b5b:	e8 f0 17 00 00       	call   80104350 <acquire>
80102b60:	83 c4 10             	add    $0x10,%esp
80102b63:	eb 18                	jmp    80102b7d <begin_op+0x2d>
80102b65:	8d 76 00             	lea    0x0(%esi),%esi
  while(1){
    if(log.committing){
      sleep(&log, &log.lock);
80102b68:	83 ec 08             	sub    $0x8,%esp
80102b6b:	68 e0 26 11 80       	push   $0x801126e0
80102b70:	68 e0 26 11 80       	push   $0x801126e0
80102b75:	e8 d6 11 00 00       	call   80103d50 <sleep>
80102b7a:	83 c4 10             	add    $0x10,%esp
void
begin_op(void)
{
  acquire(&log.lock);
  while(1){
    if(log.committing){
80102b7d:	a1 20 27 11 80       	mov    0x80112720,%eax
80102b82:	85 c0                	test   %eax,%eax
80102b84:	75 e2                	jne    80102b68 <begin_op+0x18>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
80102b86:	a1 1c 27 11 80       	mov    0x8011271c,%eax
80102b8b:	8b 15 28 27 11 80    	mov    0x80112728,%edx
80102b91:	83 c0 01             	add    $0x1,%eax
80102b94:	8d 0c 80             	lea    (%eax,%eax,4),%ecx
80102b97:	8d 14 4a             	lea    (%edx,%ecx,2),%edx
80102b9a:	83 fa 1e             	cmp    $0x1e,%edx
80102b9d:	7f c9                	jg     80102b68 <begin_op+0x18>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
      release(&log.lock);
80102b9f:	83 ec 0c             	sub    $0xc,%esp
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    } else {
      log.outstanding += 1;
80102ba2:	a3 1c 27 11 80       	mov    %eax,0x8011271c
      release(&log.lock);
80102ba7:	68 e0 26 11 80       	push   $0x801126e0
80102bac:	e8 4f 18 00 00       	call   80104400 <release>
      break;
    }
  }
}
80102bb1:	83 c4 10             	add    $0x10,%esp
80102bb4:	c9                   	leave  
80102bb5:	c3                   	ret    
80102bb6:	8d 76 00             	lea    0x0(%esi),%esi
80102bb9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80102bc0 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
80102bc0:	55                   	push   %ebp
80102bc1:	89 e5                	mov    %esp,%ebp
80102bc3:	57                   	push   %edi
80102bc4:	56                   	push   %esi
80102bc5:	53                   	push   %ebx
80102bc6:	83 ec 18             	sub    $0x18,%esp
  int do_commit = 0;

  acquire(&log.lock);
80102bc9:	68 e0 26 11 80       	push   $0x801126e0
80102bce:	e8 7d 17 00 00       	call   80104350 <acquire>
  log.outstanding -= 1;
80102bd3:	a1 1c 27 11 80       	mov    0x8011271c,%eax
  if(log.committing)
80102bd8:	8b 1d 20 27 11 80    	mov    0x80112720,%ebx
80102bde:	83 c4 10             	add    $0x10,%esp
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be1:	83 e8 01             	sub    $0x1,%eax
  if(log.committing)
80102be4:	85 db                	test   %ebx,%ebx
end_op(void)
{
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
80102be6:	a3 1c 27 11 80       	mov    %eax,0x8011271c
  if(log.committing)
80102beb:	0f 85 23 01 00 00    	jne    80102d14 <end_op+0x154>
    panic("log.committing");
  if(log.outstanding == 0){
80102bf1:	85 c0                	test   %eax,%eax
80102bf3:	0f 85 f7 00 00 00    	jne    80102cf0 <end_op+0x130>
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102bf9:	83 ec 0c             	sub    $0xc,%esp
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
  if(log.outstanding == 0){
    do_commit = 1;
    log.committing = 1;
80102bfc:	c7 05 20 27 11 80 01 	movl   $0x1,0x80112720
80102c03:	00 00 00 
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c06:	31 db                	xor    %ebx,%ebx
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
80102c08:	68 e0 26 11 80       	push   $0x801126e0
80102c0d:	e8 ee 17 00 00       	call   80104400 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
80102c12:	8b 0d 28 27 11 80    	mov    0x80112728,%ecx
80102c18:	83 c4 10             	add    $0x10,%esp
80102c1b:	85 c9                	test   %ecx,%ecx
80102c1d:	0f 8e 8a 00 00 00    	jle    80102cad <end_op+0xed>
80102c23:	90                   	nop
80102c24:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
80102c28:	a1 14 27 11 80       	mov    0x80112714,%eax
80102c2d:	83 ec 08             	sub    $0x8,%esp
80102c30:	01 d8                	add    %ebx,%eax
80102c32:	83 c0 01             	add    $0x1,%eax
80102c35:	50                   	push   %eax
80102c36:	ff 35 24 27 11 80    	pushl  0x80112724
80102c3c:	e8 8f d4 ff ff       	call   801000d0 <bread>
80102c41:	89 c6                	mov    %eax,%esi
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c43:	58                   	pop    %eax
80102c44:	5a                   	pop    %edx
80102c45:	ff 34 9d 2c 27 11 80 	pushl  -0x7feed8d4(,%ebx,4)
80102c4c:	ff 35 24 27 11 80    	pushl  0x80112724
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c52:	83 c3 01             	add    $0x1,%ebx
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
80102c55:	e8 76 d4 ff ff       	call   801000d0 <bread>
80102c5a:	89 c7                	mov    %eax,%edi
    memmove(to->data, from->data, BSIZE);
80102c5c:	8d 40 5c             	lea    0x5c(%eax),%eax
80102c5f:	83 c4 0c             	add    $0xc,%esp
80102c62:	68 00 02 00 00       	push   $0x200
80102c67:	50                   	push   %eax
80102c68:	8d 46 5c             	lea    0x5c(%esi),%eax
80102c6b:	50                   	push   %eax
80102c6c:	e8 8f 18 00 00       	call   80104500 <memmove>
    bwrite(to);  // write the log
80102c71:	89 34 24             	mov    %esi,(%esp)
80102c74:	e8 27 d5 ff ff       	call   801001a0 <bwrite>
    brelse(from);
80102c79:	89 3c 24             	mov    %edi,(%esp)
80102c7c:	e8 5f d5 ff ff       	call   801001e0 <brelse>
    brelse(to);
80102c81:	89 34 24             	mov    %esi,(%esp)
80102c84:	e8 57 d5 ff ff       	call   801001e0 <brelse>
static void
write_log(void)
{
  int tail;

  for (tail = 0; tail < log.lh.n; tail++) {
80102c89:	83 c4 10             	add    $0x10,%esp
80102c8c:	3b 1d 28 27 11 80    	cmp    0x80112728,%ebx
80102c92:	7c 94                	jl     80102c28 <end_op+0x68>
static void
commit()
{
  if (log.lh.n > 0) {
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
80102c94:	e8 b7 fd ff ff       	call   80102a50 <write_head>
    install_trans(); // Now install writes to home locations
80102c99:	e8 12 fd ff ff       	call   801029b0 <install_trans>
    log.lh.n = 0;
80102c9e:	c7 05 28 27 11 80 00 	movl   $0x0,0x80112728
80102ca5:	00 00 00 
    write_head();    // Erase the transaction from the log
80102ca8:	e8 a3 fd ff ff       	call   80102a50 <write_head>

  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
80102cad:	83 ec 0c             	sub    $0xc,%esp
80102cb0:	68 e0 26 11 80       	push   $0x801126e0
80102cb5:	e8 96 16 00 00       	call   80104350 <acquire>
    log.committing = 0;
    wakeup(&log);
80102cba:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
  if(do_commit){
    // call commit w/o holding locks, since not allowed
    // to sleep with locks.
    commit();
    acquire(&log.lock);
    log.committing = 0;
80102cc1:	c7 05 20 27 11 80 00 	movl   $0x0,0x80112720
80102cc8:	00 00 00 
    wakeup(&log);
80102ccb:	e8 40 12 00 00       	call   80103f10 <wakeup>
    release(&log.lock);
80102cd0:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
80102cd7:	e8 24 17 00 00       	call   80104400 <release>
80102cdc:	83 c4 10             	add    $0x10,%esp
  }
}
80102cdf:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102ce2:	5b                   	pop    %ebx
80102ce3:	5e                   	pop    %esi
80102ce4:	5f                   	pop    %edi
80102ce5:	5d                   	pop    %ebp
80102ce6:	c3                   	ret    
80102ce7:	89 f6                	mov    %esi,%esi
80102ce9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    log.committing = 1;
  } else {
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
80102cf0:	83 ec 0c             	sub    $0xc,%esp
80102cf3:	68 e0 26 11 80       	push   $0x801126e0
80102cf8:	e8 13 12 00 00       	call   80103f10 <wakeup>
  }
  release(&log.lock);
80102cfd:	c7 04 24 e0 26 11 80 	movl   $0x801126e0,(%esp)
80102d04:	e8 f7 16 00 00       	call   80104400 <release>
80102d09:	83 c4 10             	add    $0x10,%esp
    acquire(&log.lock);
    log.committing = 0;
    wakeup(&log);
    release(&log.lock);
  }
}
80102d0c:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102d0f:	5b                   	pop    %ebx
80102d10:	5e                   	pop    %esi
80102d11:	5f                   	pop    %edi
80102d12:	5d                   	pop    %ebp
80102d13:	c3                   	ret    
  int do_commit = 0;

  acquire(&log.lock);
  log.outstanding -= 1;
  if(log.committing)
    panic("log.committing");
80102d14:	83 ec 0c             	sub    $0xc,%esp
80102d17:	68 04 75 10 80       	push   $0x80107504
80102d1c:	e8 4f d6 ff ff       	call   80100370 <panic>
80102d21:	eb 0d                	jmp    80102d30 <log_write>
80102d23:	90                   	nop
80102d24:	90                   	nop
80102d25:	90                   	nop
80102d26:	90                   	nop
80102d27:	90                   	nop
80102d28:	90                   	nop
80102d29:	90                   	nop
80102d2a:	90                   	nop
80102d2b:	90                   	nop
80102d2c:	90                   	nop
80102d2d:	90                   	nop
80102d2e:	90                   	nop
80102d2f:	90                   	nop

80102d30 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d30:	55                   	push   %ebp
80102d31:	89 e5                	mov    %esp,%ebp
80102d33:	53                   	push   %ebx
80102d34:	83 ec 04             	sub    $0x4,%esp
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d37:	8b 15 28 27 11 80    	mov    0x80112728,%edx
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
80102d3d:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
80102d40:	83 fa 1d             	cmp    $0x1d,%edx
80102d43:	0f 8f 97 00 00 00    	jg     80102de0 <log_write+0xb0>
80102d49:	a1 18 27 11 80       	mov    0x80112718,%eax
80102d4e:	83 e8 01             	sub    $0x1,%eax
80102d51:	39 c2                	cmp    %eax,%edx
80102d53:	0f 8d 87 00 00 00    	jge    80102de0 <log_write+0xb0>
    panic("too big a transaction");
  if (log.outstanding < 1)
80102d59:	a1 1c 27 11 80       	mov    0x8011271c,%eax
80102d5e:	85 c0                	test   %eax,%eax
80102d60:	0f 8e 87 00 00 00    	jle    80102ded <log_write+0xbd>
    panic("log_write outside of trans");

  acquire(&log.lock);
80102d66:	83 ec 0c             	sub    $0xc,%esp
80102d69:	68 e0 26 11 80       	push   $0x801126e0
80102d6e:	e8 dd 15 00 00       	call   80104350 <acquire>
  for (i = 0; i < log.lh.n; i++) {
80102d73:	8b 15 28 27 11 80    	mov    0x80112728,%edx
80102d79:	83 c4 10             	add    $0x10,%esp
80102d7c:	83 fa 00             	cmp    $0x0,%edx
80102d7f:	7e 50                	jle    80102dd1 <log_write+0xa1>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d81:	8b 4b 08             	mov    0x8(%ebx),%ecx
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d84:	31 c0                	xor    %eax,%eax
    if (log.lh.block[i] == b->blockno)   // log absorbtion
80102d86:	3b 0d 2c 27 11 80    	cmp    0x8011272c,%ecx
80102d8c:	75 0b                	jne    80102d99 <log_write+0x69>
80102d8e:	eb 38                	jmp    80102dc8 <log_write+0x98>
80102d90:	39 0c 85 2c 27 11 80 	cmp    %ecx,-0x7feed8d4(,%eax,4)
80102d97:	74 2f                	je     80102dc8 <log_write+0x98>
    panic("too big a transaction");
  if (log.outstanding < 1)
    panic("log_write outside of trans");

  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
80102d99:	83 c0 01             	add    $0x1,%eax
80102d9c:	39 d0                	cmp    %edx,%eax
80102d9e:	75 f0                	jne    80102d90 <log_write+0x60>
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102da0:	89 0c 95 2c 27 11 80 	mov    %ecx,-0x7feed8d4(,%edx,4)
  if (i == log.lh.n)
    log.lh.n++;
80102da7:	83 c2 01             	add    $0x1,%edx
80102daa:	89 15 28 27 11 80    	mov    %edx,0x80112728
  b->flags |= B_DIRTY; // prevent eviction
80102db0:	83 0b 04             	orl    $0x4,(%ebx)
  release(&log.lock);
80102db3:	c7 45 08 e0 26 11 80 	movl   $0x801126e0,0x8(%ebp)
}
80102dba:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80102dbd:	c9                   	leave  
  }
  log.lh.block[i] = b->blockno;
  if (i == log.lh.n)
    log.lh.n++;
  b->flags |= B_DIRTY; // prevent eviction
  release(&log.lock);
80102dbe:	e9 3d 16 00 00       	jmp    80104400 <release>
80102dc3:	90                   	nop
80102dc4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  acquire(&log.lock);
  for (i = 0; i < log.lh.n; i++) {
    if (log.lh.block[i] == b->blockno)   // log absorbtion
      break;
  }
  log.lh.block[i] = b->blockno;
80102dc8:	89 0c 85 2c 27 11 80 	mov    %ecx,-0x7feed8d4(,%eax,4)
80102dcf:	eb df                	jmp    80102db0 <log_write+0x80>
80102dd1:	8b 43 08             	mov    0x8(%ebx),%eax
80102dd4:	a3 2c 27 11 80       	mov    %eax,0x8011272c
  if (i == log.lh.n)
80102dd9:	75 d5                	jne    80102db0 <log_write+0x80>
80102ddb:	eb ca                	jmp    80102da7 <log_write+0x77>
80102ddd:	8d 76 00             	lea    0x0(%esi),%esi
log_write(struct buf *b)
{
  int i;

  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    panic("too big a transaction");
80102de0:	83 ec 0c             	sub    $0xc,%esp
80102de3:	68 13 75 10 80       	push   $0x80107513
80102de8:	e8 83 d5 ff ff       	call   80100370 <panic>
  if (log.outstanding < 1)
    panic("log_write outside of trans");
80102ded:	83 ec 0c             	sub    $0xc,%esp
80102df0:	68 29 75 10 80       	push   $0x80107529
80102df5:	e8 76 d5 ff ff       	call   80100370 <panic>
80102dfa:	66 90                	xchg   %ax,%ax
80102dfc:	66 90                	xchg   %ax,%ax
80102dfe:	66 90                	xchg   %ax,%ax

80102e00 <mpmain>:
}

// Common CPU setup code.
static void
mpmain(void)
{
80102e00:	55                   	push   %ebp
80102e01:	89 e5                	mov    %esp,%ebp
80102e03:	53                   	push   %ebx
80102e04:	83 ec 04             	sub    $0x4,%esp
  cprintf("cpu%d: starting %d\n", cpuid(), cpuid());
80102e07:	e8 74 09 00 00       	call   80103780 <cpuid>
80102e0c:	89 c3                	mov    %eax,%ebx
80102e0e:	e8 6d 09 00 00       	call   80103780 <cpuid>
80102e13:	83 ec 04             	sub    $0x4,%esp
80102e16:	53                   	push   %ebx
80102e17:	50                   	push   %eax
80102e18:	68 44 75 10 80       	push   $0x80107544
80102e1d:	e8 3e d8 ff ff       	call   80100660 <cprintf>
  idtinit();       // load idt register
80102e22:	e8 49 2a 00 00       	call   80105870 <idtinit>
  xchg(&(mycpu()->started), 1); // tell startothers() we're up
80102e27:	e8 d4 08 00 00       	call   80103700 <mycpu>
80102e2c:	89 c2                	mov    %eax,%edx
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80102e2e:	b8 01 00 00 00       	mov    $0x1,%eax
80102e33:	f0 87 82 a0 00 00 00 	lock xchg %eax,0xa0(%edx)
  scheduler();     // start running processes
80102e3a:	e8 21 0c 00 00       	call   80103a60 <scheduler>
80102e3f:	90                   	nop

80102e40 <mpenter>:
}

// Other CPUs jump here from entryother.S.
static void
mpenter(void)
{
80102e40:	55                   	push   %ebp
80102e41:	89 e5                	mov    %esp,%ebp
80102e43:	83 ec 08             	sub    $0x8,%esp
  switchkvm();
80102e46:	e8 45 3b 00 00       	call   80106990 <switchkvm>
  seginit();
80102e4b:	e8 40 3a 00 00       	call   80106890 <seginit>
  lapicinit();
80102e50:	e8 9b f7 ff ff       	call   801025f0 <lapicinit>
  mpmain();
80102e55:	e8 a6 ff ff ff       	call   80102e00 <mpmain>
80102e5a:	66 90                	xchg   %ax,%ax
80102e5c:	66 90                	xchg   %ax,%ax
80102e5e:	66 90                	xchg   %ax,%ax

80102e60 <main>:
// Bootstrap processor starts running C code here.
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
80102e60:	8d 4c 24 04          	lea    0x4(%esp),%ecx
80102e64:	83 e4 f0             	and    $0xfffffff0,%esp
80102e67:	ff 71 fc             	pushl  -0x4(%ecx)
80102e6a:	55                   	push   %ebp
80102e6b:	89 e5                	mov    %esp,%ebp
80102e6d:	53                   	push   %ebx
80102e6e:	51                   	push   %ecx
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102e6f:	bb e0 27 11 80       	mov    $0x801127e0,%ebx
// Allocate a real stack and switch to it, first
// doing some setup required for memory allocator to work.
int
main(void)
{
  kinit1(end, P2V(4*1024*1024)); // phys page allocator
80102e74:	83 ec 08             	sub    $0x8,%esp
80102e77:	68 00 00 40 80       	push   $0x80400000
80102e7c:	68 08 57 11 80       	push   $0x80115708
80102e81:	e8 3a f5 ff ff       	call   801023c0 <kinit1>
  kvmalloc();      // kernel page table
80102e86:	e8 a5 3f 00 00       	call   80106e30 <kvmalloc>
  mpinit();        // detect other processors
80102e8b:	e8 70 01 00 00       	call   80103000 <mpinit>
  lapicinit();     // interrupt controller
80102e90:	e8 5b f7 ff ff       	call   801025f0 <lapicinit>
  seginit();       // segment descriptors
80102e95:	e8 f6 39 00 00       	call   80106890 <seginit>
  picinit();       // disable pic
80102e9a:	e8 31 03 00 00       	call   801031d0 <picinit>
  ioapicinit();    // another interrupt controller
80102e9f:	e8 4c f3 ff ff       	call   801021f0 <ioapicinit>
  consoleinit();   // console hardware
80102ea4:	e8 f7 da ff ff       	call   801009a0 <consoleinit>
  uartinit();      // serial port
80102ea9:	e8 b2 2c 00 00       	call   80105b60 <uartinit>
  pinit();         // process table
80102eae:	e8 2d 08 00 00       	call   801036e0 <pinit>
  tvinit();        // trap vectors
80102eb3:	e8 18 29 00 00       	call   801057d0 <tvinit>
  binit();         // buffer cache
80102eb8:	e8 83 d1 ff ff       	call   80100040 <binit>
  fileinit();      // file table
80102ebd:	e8 8e de ff ff       	call   80100d50 <fileinit>
  ideinit();       // disk 
80102ec2:	e8 09 f1 ff ff       	call   80101fd0 <ideinit>

  // Write entry code to unused memory at 0x7000.
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);
80102ec7:	83 c4 0c             	add    $0xc,%esp
80102eca:	68 8a 00 00 00       	push   $0x8a
80102ecf:	68 ec a4 10 80       	push   $0x8010a4ec
80102ed4:	68 00 70 00 80       	push   $0x80007000
80102ed9:	e8 22 16 00 00       	call   80104500 <memmove>

  for(c = cpus; c < cpus+ncpu; c++){
80102ede:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80102ee5:	00 00 00 
80102ee8:	83 c4 10             	add    $0x10,%esp
80102eeb:	05 e0 27 11 80       	add    $0x801127e0,%eax
80102ef0:	39 d8                	cmp    %ebx,%eax
80102ef2:	76 6f                	jbe    80102f63 <main+0x103>
80102ef4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(c == mycpu())  // We've started already.
80102ef8:	e8 03 08 00 00       	call   80103700 <mycpu>
80102efd:	39 d8                	cmp    %ebx,%eax
80102eff:	74 49                	je     80102f4a <main+0xea>
      continue;

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
80102f01:	e8 8a f5 ff ff       	call   80102490 <kalloc>
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f06:	05 00 10 00 00       	add    $0x1000,%eax
    *(void(**)(void))(code-8) = mpenter;
80102f0b:	c7 05 f8 6f 00 80 40 	movl   $0x80102e40,0x80006ff8
80102f12:	2e 10 80 
    *(int**)(code-12) = (void *) V2P(entrypgdir);
80102f15:	c7 05 f4 6f 00 80 00 	movl   $0x109000,0x80006ff4
80102f1c:	90 10 00 

    // Tell entryother.S what stack to use, where to enter, and what
    // pgdir to use. We cannot use kpgdir yet, because the AP processor
    // is running in low  memory, so we use entrypgdir for the APs too.
    stack = kalloc();
    *(void**)(code-4) = stack + KSTACKSIZE;
80102f1f:	a3 fc 6f 00 80       	mov    %eax,0x80006ffc
    *(void(**)(void))(code-8) = mpenter;
    *(int**)(code-12) = (void *) V2P(entrypgdir);

    lapicstartap(c->apicid, V2P(code));
80102f24:	0f b6 03             	movzbl (%ebx),%eax
80102f27:	83 ec 08             	sub    $0x8,%esp
80102f2a:	68 00 70 00 00       	push   $0x7000
80102f2f:	50                   	push   %eax
80102f30:	e8 0b f8 ff ff       	call   80102740 <lapicstartap>
80102f35:	83 c4 10             	add    $0x10,%esp
80102f38:	90                   	nop
80102f39:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

    // wait for cpu to finish mpmain()
    while(c->started == 0)
80102f40:	8b 83 a0 00 00 00    	mov    0xa0(%ebx),%eax
80102f46:	85 c0                	test   %eax,%eax
80102f48:	74 f6                	je     80102f40 <main+0xe0>
  // The linker has placed the image of entryother.S in
  // _binary_entryother_start.
  code = P2V(0x7000);
  memmove(code, _binary_entryother_start, (uint)_binary_entryother_size);

  for(c = cpus; c < cpus+ncpu; c++){
80102f4a:	69 05 60 2d 11 80 b0 	imul   $0xb0,0x80112d60,%eax
80102f51:	00 00 00 
80102f54:	81 c3 b0 00 00 00    	add    $0xb0,%ebx
80102f5a:	05 e0 27 11 80       	add    $0x801127e0,%eax
80102f5f:	39 c3                	cmp    %eax,%ebx
80102f61:	72 95                	jb     80102ef8 <main+0x98>
  tvinit();        // trap vectors
  binit();         // buffer cache
  fileinit();      // file table
  ideinit();       // disk 
  startothers();   // start other processors
  kinit2(P2V(4*1024*1024), P2V(PHYSTOP)); // must come after startothers()
80102f63:	83 ec 08             	sub    $0x8,%esp
80102f66:	68 00 00 00 8e       	push   $0x8e000000
80102f6b:	68 00 00 40 80       	push   $0x80400000
80102f70:	e8 bb f4 ff ff       	call   80102430 <kinit2>
  userinit();      // first user process
80102f75:	e8 56 08 00 00       	call   801037d0 <userinit>
  mpmain();        // finish this processor's setup
80102f7a:	e8 81 fe ff ff       	call   80102e00 <mpmain>
80102f7f:	90                   	nop

80102f80 <mpsearch1>:
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f80:	55                   	push   %ebp
80102f81:	89 e5                	mov    %esp,%ebp
80102f83:	57                   	push   %edi
80102f84:	56                   	push   %esi
  uchar *e, *p, *addr;

  addr = P2V(a);
80102f85:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8b:	53                   	push   %ebx
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
80102f8c:	8d 1c 16             	lea    (%esi,%edx,1),%ebx
}

// Look for an MP structure in the len bytes at addr.
static struct mp*
mpsearch1(uint a, int len)
{
80102f8f:	83 ec 0c             	sub    $0xc,%esp
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102f92:	39 de                	cmp    %ebx,%esi
80102f94:	73 48                	jae    80102fde <mpsearch1+0x5e>
80102f96:	8d 76 00             	lea    0x0(%esi),%esi
80102f99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fa0:	83 ec 04             	sub    $0x4,%esp
80102fa3:	8d 7e 10             	lea    0x10(%esi),%edi
80102fa6:	6a 04                	push   $0x4
80102fa8:	68 58 75 10 80       	push   $0x80107558
80102fad:	56                   	push   %esi
80102fae:	e8 ed 14 00 00       	call   801044a0 <memcmp>
80102fb3:	83 c4 10             	add    $0x10,%esp
80102fb6:	85 c0                	test   %eax,%eax
80102fb8:	75 1e                	jne    80102fd8 <mpsearch1+0x58>
80102fba:	8d 7e 10             	lea    0x10(%esi),%edi
80102fbd:	89 f2                	mov    %esi,%edx
80102fbf:	31 c9                	xor    %ecx,%ecx
80102fc1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
    sum += addr[i];
80102fc8:	0f b6 02             	movzbl (%edx),%eax
80102fcb:	83 c2 01             	add    $0x1,%edx
80102fce:	01 c1                	add    %eax,%ecx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
80102fd0:	39 fa                	cmp    %edi,%edx
80102fd2:	75 f4                	jne    80102fc8 <mpsearch1+0x48>
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
80102fd4:	84 c9                	test   %cl,%cl
80102fd6:	74 10                	je     80102fe8 <mpsearch1+0x68>
{
  uchar *e, *p, *addr;

  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
80102fd8:	39 fb                	cmp    %edi,%ebx
80102fda:	89 fe                	mov    %edi,%esi
80102fdc:	77 c2                	ja     80102fa0 <mpsearch1+0x20>
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
}
80102fde:	8d 65 f4             	lea    -0xc(%ebp),%esp
  addr = P2V(a);
  e = addr+len;
  for(p = addr; p < e; p += sizeof(struct mp))
    if(memcmp(p, "_MP_", 4) == 0 && sum(p, sizeof(struct mp)) == 0)
      return (struct mp*)p;
  return 0;
80102fe1:	31 c0                	xor    %eax,%eax
}
80102fe3:	5b                   	pop    %ebx
80102fe4:	5e                   	pop    %esi
80102fe5:	5f                   	pop    %edi
80102fe6:	5d                   	pop    %ebp
80102fe7:	c3                   	ret    
80102fe8:	8d 65 f4             	lea    -0xc(%ebp),%esp
80102feb:	89 f0                	mov    %esi,%eax
80102fed:	5b                   	pop    %ebx
80102fee:	5e                   	pop    %esi
80102fef:	5f                   	pop    %edi
80102ff0:	5d                   	pop    %ebp
80102ff1:	c3                   	ret    
80102ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80102ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103000 <mpinit>:
  return conf;
}

void
mpinit(void)
{
80103000:	55                   	push   %ebp
80103001:	89 e5                	mov    %esp,%ebp
80103003:	57                   	push   %edi
80103004:	56                   	push   %esi
80103005:	53                   	push   %ebx
80103006:	83 ec 1c             	sub    $0x1c,%esp
  uchar *bda;
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
80103009:	0f b6 05 0f 04 00 80 	movzbl 0x8000040f,%eax
80103010:	0f b6 15 0e 04 00 80 	movzbl 0x8000040e,%edx
80103017:	c1 e0 08             	shl    $0x8,%eax
8010301a:	09 d0                	or     %edx,%eax
8010301c:	c1 e0 04             	shl    $0x4,%eax
8010301f:	85 c0                	test   %eax,%eax
80103021:	75 1b                	jne    8010303e <mpinit+0x3e>
    if((mp = mpsearch1(p, 1024)))
      return mp;
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
80103023:	0f b6 05 14 04 00 80 	movzbl 0x80000414,%eax
8010302a:	0f b6 15 13 04 00 80 	movzbl 0x80000413,%edx
80103031:	c1 e0 08             	shl    $0x8,%eax
80103034:	09 d0                	or     %edx,%eax
80103036:	c1 e0 0a             	shl    $0xa,%eax
80103039:	2d 00 04 00 00       	sub    $0x400,%eax
  uint p;
  struct mp *mp;

  bda = (uchar *) P2V(0x400);
  if((p = ((bda[0x0F]<<8)| bda[0x0E]) << 4)){
    if((mp = mpsearch1(p, 1024)))
8010303e:	ba 00 04 00 00       	mov    $0x400,%edx
80103043:	e8 38 ff ff ff       	call   80102f80 <mpsearch1>
80103048:	85 c0                	test   %eax,%eax
8010304a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010304d:	0f 84 37 01 00 00    	je     8010318a <mpinit+0x18a>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103053:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103056:	8b 58 04             	mov    0x4(%eax),%ebx
80103059:	85 db                	test   %ebx,%ebx
8010305b:	0f 84 43 01 00 00    	je     801031a4 <mpinit+0x1a4>
    return 0;
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
80103061:	8d b3 00 00 00 80    	lea    -0x80000000(%ebx),%esi
  if(memcmp(conf, "PCMP", 4) != 0)
80103067:	83 ec 04             	sub    $0x4,%esp
8010306a:	6a 04                	push   $0x4
8010306c:	68 5d 75 10 80       	push   $0x8010755d
80103071:	56                   	push   %esi
80103072:	e8 29 14 00 00       	call   801044a0 <memcmp>
80103077:	83 c4 10             	add    $0x10,%esp
8010307a:	85 c0                	test   %eax,%eax
8010307c:	0f 85 22 01 00 00    	jne    801031a4 <mpinit+0x1a4>
    return 0;
  if(conf->version != 1 && conf->version != 4)
80103082:	0f b6 83 06 00 00 80 	movzbl -0x7ffffffa(%ebx),%eax
80103089:	3c 01                	cmp    $0x1,%al
8010308b:	74 08                	je     80103095 <mpinit+0x95>
8010308d:	3c 04                	cmp    $0x4,%al
8010308f:	0f 85 0f 01 00 00    	jne    801031a4 <mpinit+0x1a4>
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
80103095:	0f b7 bb 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edi
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
8010309c:	85 ff                	test   %edi,%edi
8010309e:	74 21                	je     801030c1 <mpinit+0xc1>
801030a0:	31 d2                	xor    %edx,%edx
801030a2:	31 c0                	xor    %eax,%eax
801030a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    sum += addr[i];
801030a8:	0f b6 8c 03 00 00 00 	movzbl -0x80000000(%ebx,%eax,1),%ecx
801030af:	80 
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b0:	83 c0 01             	add    $0x1,%eax
    sum += addr[i];
801030b3:	01 ca                	add    %ecx,%edx
sum(uchar *addr, int len)
{
  int i, sum;

  sum = 0;
  for(i=0; i<len; i++)
801030b5:	39 c7                	cmp    %eax,%edi
801030b7:	75 ef                	jne    801030a8 <mpinit+0xa8>
  conf = (struct mpconf*) P2V((uint) mp->physaddr);
  if(memcmp(conf, "PCMP", 4) != 0)
    return 0;
  if(conf->version != 1 && conf->version != 4)
    return 0;
  if(sum((uchar*)conf, conf->length) != 0)
801030b9:	84 d2                	test   %dl,%dl
801030bb:	0f 85 e3 00 00 00    	jne    801031a4 <mpinit+0x1a4>
  struct mp *mp;
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
801030c1:	85 f6                	test   %esi,%esi
801030c3:	0f 84 db 00 00 00    	je     801031a4 <mpinit+0x1a4>
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
801030c9:	8b 83 24 00 00 80    	mov    -0x7fffffdc(%ebx),%eax
801030cf:	a3 dc 26 11 80       	mov    %eax,0x801126dc
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030d4:	0f b7 93 04 00 00 80 	movzwl -0x7ffffffc(%ebx),%edx
801030db:	8d 83 2c 00 00 80    	lea    -0x7fffffd4(%ebx),%eax
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
801030e1:	bb 01 00 00 00       	mov    $0x1,%ebx
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
801030e6:	01 d6                	add    %edx,%esi
801030e8:	90                   	nop
801030e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801030f0:	39 c6                	cmp    %eax,%esi
801030f2:	76 23                	jbe    80103117 <mpinit+0x117>
801030f4:	0f b6 10             	movzbl (%eax),%edx
    switch(*p){
801030f7:	80 fa 04             	cmp    $0x4,%dl
801030fa:	0f 87 c0 00 00 00    	ja     801031c0 <mpinit+0x1c0>
80103100:	ff 24 95 9c 75 10 80 	jmp    *-0x7fef8a64(,%edx,4)
80103107:	89 f6                	mov    %esi,%esi
80103109:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      p += sizeof(struct mpioapic);
      continue;
    case MPBUS:
    case MPIOINTR:
    case MPLINTR:
      p += 8;
80103110:	83 c0 08             	add    $0x8,%eax

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
  ismp = 1;
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
80103113:	39 c6                	cmp    %eax,%esi
80103115:	77 dd                	ja     801030f4 <mpinit+0xf4>
    default:
      ismp = 0;
      break;
    }
  }
  if(!ismp)
80103117:	85 db                	test   %ebx,%ebx
80103119:	0f 84 92 00 00 00    	je     801031b1 <mpinit+0x1b1>
    panic("Didn't find a suitable machine");

  if(mp->imcrp){
8010311f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80103122:	80 78 0c 00          	cmpb   $0x0,0xc(%eax)
80103126:	74 15                	je     8010313d <mpinit+0x13d>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103128:	ba 22 00 00 00       	mov    $0x22,%edx
8010312d:	b8 70 00 00 00       	mov    $0x70,%eax
80103132:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80103133:	ba 23 00 00 00       	mov    $0x23,%edx
80103138:	ec                   	in     (%dx),%al
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80103139:	83 c8 01             	or     $0x1,%eax
8010313c:	ee                   	out    %al,(%dx)
    // Bochs doesn't support IMCR, so this doesn't run on Bochs.
    // But it would on real hardware.
    outb(0x22, 0x70);   // Select IMCR
    outb(0x23, inb(0x23) | 1);  // Mask external interrupts.
  }
}
8010313d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103140:	5b                   	pop    %ebx
80103141:	5e                   	pop    %esi
80103142:	5f                   	pop    %edi
80103143:	5d                   	pop    %ebp
80103144:	c3                   	ret    
80103145:	8d 76 00             	lea    0x0(%esi),%esi
  lapic = (uint*)conf->lapicaddr;
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
80103148:	8b 0d 60 2d 11 80    	mov    0x80112d60,%ecx
8010314e:	83 f9 07             	cmp    $0x7,%ecx
80103151:	7f 19                	jg     8010316c <mpinit+0x16c>
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103153:	0f b6 50 01          	movzbl 0x1(%eax),%edx
80103157:	69 f9 b0 00 00 00    	imul   $0xb0,%ecx,%edi
        ncpu++;
8010315d:	83 c1 01             	add    $0x1,%ecx
80103160:	89 0d 60 2d 11 80    	mov    %ecx,0x80112d60
  for(p=(uchar*)(conf+1), e=(uchar*)conf+conf->length; p<e; ){
    switch(*p){
    case MPPROC:
      proc = (struct mpproc*)p;
      if(ncpu < NCPU) {
        cpus[ncpu].apicid = proc->apicid;  // apicid may differ from ncpu
80103166:	88 97 e0 27 11 80    	mov    %dl,-0x7feed820(%edi)
        ncpu++;
      }
      p += sizeof(struct mpproc);
8010316c:	83 c0 14             	add    $0x14,%eax
      continue;
8010316f:	e9 7c ff ff ff       	jmp    801030f0 <mpinit+0xf0>
80103174:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
80103178:	0f b6 50 01          	movzbl 0x1(%eax),%edx
      p += sizeof(struct mpioapic);
8010317c:	83 c0 08             	add    $0x8,%eax
      }
      p += sizeof(struct mpproc);
      continue;
    case MPIOAPIC:
      ioapic = (struct mpioapic*)p;
      ioapicid = ioapic->apicno;
8010317f:	88 15 c0 27 11 80    	mov    %dl,0x801127c0
      p += sizeof(struct mpioapic);
      continue;
80103185:	e9 66 ff ff ff       	jmp    801030f0 <mpinit+0xf0>
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010318a:	ba 00 00 01 00       	mov    $0x10000,%edx
8010318f:	b8 00 00 0f 00       	mov    $0xf0000,%eax
80103194:	e8 e7 fd ff ff       	call   80102f80 <mpsearch1>
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
80103199:	85 c0                	test   %eax,%eax
  } else {
    p = ((bda[0x14]<<8)|bda[0x13])*1024;
    if((mp = mpsearch1(p-1024, 1024)))
      return mp;
  }
  return mpsearch1(0xF0000, 0x10000);
8010319b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
mpconfig(struct mp **pmp)
{
  struct mpconf *conf;
  struct mp *mp;

  if((mp = mpsearch()) == 0 || mp->physaddr == 0)
8010319e:	0f 85 af fe ff ff    	jne    80103053 <mpinit+0x53>
  struct mpconf *conf;
  struct mpproc *proc;
  struct mpioapic *ioapic;

  if((conf = mpconfig(&mp)) == 0)
    panic("Expect to run on an SMP");
801031a4:	83 ec 0c             	sub    $0xc,%esp
801031a7:	68 62 75 10 80       	push   $0x80107562
801031ac:	e8 bf d1 ff ff       	call   80100370 <panic>
      ismp = 0;
      break;
    }
  }
  if(!ismp)
    panic("Didn't find a suitable machine");
801031b1:	83 ec 0c             	sub    $0xc,%esp
801031b4:	68 7c 75 10 80       	push   $0x8010757c
801031b9:	e8 b2 d1 ff ff       	call   80100370 <panic>
801031be:	66 90                	xchg   %ax,%ax
    case MPIOINTR:
    case MPLINTR:
      p += 8;
      continue;
    default:
      ismp = 0;
801031c0:	31 db                	xor    %ebx,%ebx
801031c2:	e9 30 ff ff ff       	jmp    801030f7 <mpinit+0xf7>
801031c7:	66 90                	xchg   %ax,%ax
801031c9:	66 90                	xchg   %ax,%ax
801031cb:	66 90                	xchg   %ax,%ax
801031cd:	66 90                	xchg   %ax,%ax
801031cf:	90                   	nop

801031d0 <picinit>:
#define IO_PIC2         0xA0    // Slave (IRQs 8-15)

// Don't use the 8259A interrupt controllers.  Xv6 assumes SMP hardware.
void
picinit(void)
{
801031d0:	55                   	push   %ebp
801031d1:	ba 21 00 00 00       	mov    $0x21,%edx
801031d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801031db:	89 e5                	mov    %esp,%ebp
801031dd:	ee                   	out    %al,(%dx)
801031de:	ba a1 00 00 00       	mov    $0xa1,%edx
801031e3:	ee                   	out    %al,(%dx)
  // mask all interrupts
  outb(IO_PIC1+1, 0xFF);
  outb(IO_PIC2+1, 0xFF);
}
801031e4:	5d                   	pop    %ebp
801031e5:	c3                   	ret    
801031e6:	66 90                	xchg   %ax,%ax
801031e8:	66 90                	xchg   %ax,%ax
801031ea:	66 90                	xchg   %ax,%ax
801031ec:	66 90                	xchg   %ax,%ax
801031ee:	66 90                	xchg   %ax,%ax

801031f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
801031f0:	55                   	push   %ebp
801031f1:	89 e5                	mov    %esp,%ebp
801031f3:	57                   	push   %edi
801031f4:	56                   	push   %esi
801031f5:	53                   	push   %ebx
801031f6:	83 ec 0c             	sub    $0xc,%esp
801031f9:	8b 75 08             	mov    0x8(%ebp),%esi
801031fc:	8b 5d 0c             	mov    0xc(%ebp),%ebx
  struct pipe *p;

  p = 0;
  *f0 = *f1 = 0;
801031ff:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103205:	c7 06 00 00 00 00    	movl   $0x0,(%esi)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
8010320b:	e8 60 db ff ff       	call   80100d70 <filealloc>
80103210:	85 c0                	test   %eax,%eax
80103212:	89 06                	mov    %eax,(%esi)
80103214:	0f 84 a8 00 00 00    	je     801032c2 <pipealloc+0xd2>
8010321a:	e8 51 db ff ff       	call   80100d70 <filealloc>
8010321f:	85 c0                	test   %eax,%eax
80103221:	89 03                	mov    %eax,(%ebx)
80103223:	0f 84 87 00 00 00    	je     801032b0 <pipealloc+0xc0>
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
80103229:	e8 62 f2 ff ff       	call   80102490 <kalloc>
8010322e:	85 c0                	test   %eax,%eax
80103230:	89 c7                	mov    %eax,%edi
80103232:	0f 84 b0 00 00 00    	je     801032e8 <pipealloc+0xf8>
    goto bad;
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
80103238:	83 ec 08             	sub    $0x8,%esp
  *f0 = *f1 = 0;
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    goto bad;
  if((p = (struct pipe*)kalloc()) == 0)
    goto bad;
  p->readopen = 1;
8010323b:	c7 80 3c 02 00 00 01 	movl   $0x1,0x23c(%eax)
80103242:	00 00 00 
  p->writeopen = 1;
80103245:	c7 80 40 02 00 00 01 	movl   $0x1,0x240(%eax)
8010324c:	00 00 00 
  p->nwrite = 0;
8010324f:	c7 80 38 02 00 00 00 	movl   $0x0,0x238(%eax)
80103256:	00 00 00 
  p->nread = 0;
80103259:	c7 80 34 02 00 00 00 	movl   $0x0,0x234(%eax)
80103260:	00 00 00 
  initlock(&p->lock, "pipe");
80103263:	68 b0 75 10 80       	push   $0x801075b0
80103268:	50                   	push   %eax
80103269:	e8 82 0f 00 00       	call   801041f0 <initlock>
  (*f0)->type = FD_PIPE;
8010326e:	8b 06                	mov    (%esi),%eax
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
80103270:	83 c4 10             	add    $0x10,%esp
  p->readopen = 1;
  p->writeopen = 1;
  p->nwrite = 0;
  p->nread = 0;
  initlock(&p->lock, "pipe");
  (*f0)->type = FD_PIPE;
80103273:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f0)->readable = 1;
80103279:	8b 06                	mov    (%esi),%eax
8010327b:	c6 40 08 01          	movb   $0x1,0x8(%eax)
  (*f0)->writable = 0;
8010327f:	8b 06                	mov    (%esi),%eax
80103281:	c6 40 09 00          	movb   $0x0,0x9(%eax)
  (*f0)->pipe = p;
80103285:	8b 06                	mov    (%esi),%eax
80103287:	89 78 0c             	mov    %edi,0xc(%eax)
  (*f1)->type = FD_PIPE;
8010328a:	8b 03                	mov    (%ebx),%eax
8010328c:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
  (*f1)->readable = 0;
80103292:	8b 03                	mov    (%ebx),%eax
80103294:	c6 40 08 00          	movb   $0x0,0x8(%eax)
  (*f1)->writable = 1;
80103298:	8b 03                	mov    (%ebx),%eax
8010329a:	c6 40 09 01          	movb   $0x1,0x9(%eax)
  (*f1)->pipe = p;
8010329e:	8b 03                	mov    (%ebx),%eax
801032a0:	89 78 0c             	mov    %edi,0xc(%eax)
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a3:	8d 65 f4             	lea    -0xc(%ebp),%esp
  (*f0)->pipe = p;
  (*f1)->type = FD_PIPE;
  (*f1)->readable = 0;
  (*f1)->writable = 1;
  (*f1)->pipe = p;
  return 0;
801032a6:	31 c0                	xor    %eax,%eax
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
}
801032a8:	5b                   	pop    %ebx
801032a9:	5e                   	pop    %esi
801032aa:	5f                   	pop    %edi
801032ab:	5d                   	pop    %ebp
801032ac:	c3                   	ret    
801032ad:	8d 76 00             	lea    0x0(%esi),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032b0:	8b 06                	mov    (%esi),%eax
801032b2:	85 c0                	test   %eax,%eax
801032b4:	74 1e                	je     801032d4 <pipealloc+0xe4>
    fileclose(*f0);
801032b6:	83 ec 0c             	sub    $0xc,%esp
801032b9:	50                   	push   %eax
801032ba:	e8 71 db ff ff       	call   80100e30 <fileclose>
801032bf:	83 c4 10             	add    $0x10,%esp
  if(*f1)
801032c2:	8b 03                	mov    (%ebx),%eax
801032c4:	85 c0                	test   %eax,%eax
801032c6:	74 0c                	je     801032d4 <pipealloc+0xe4>
    fileclose(*f1);
801032c8:	83 ec 0c             	sub    $0xc,%esp
801032cb:	50                   	push   %eax
801032cc:	e8 5f db ff ff       	call   80100e30 <fileclose>
801032d1:	83 c4 10             	add    $0x10,%esp
  return -1;
}
801032d4:	8d 65 f4             	lea    -0xc(%ebp),%esp
    kfree((char*)p);
  if(*f0)
    fileclose(*f0);
  if(*f1)
    fileclose(*f1);
  return -1;
801032d7:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
801032dc:	5b                   	pop    %ebx
801032dd:	5e                   	pop    %esi
801032de:	5f                   	pop    %edi
801032df:	5d                   	pop    %ebp
801032e0:	c3                   	ret    
801032e1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

//PAGEBREAK: 20
 bad:
  if(p)
    kfree((char*)p);
  if(*f0)
801032e8:	8b 06                	mov    (%esi),%eax
801032ea:	85 c0                	test   %eax,%eax
801032ec:	75 c8                	jne    801032b6 <pipealloc+0xc6>
801032ee:	eb d2                	jmp    801032c2 <pipealloc+0xd2>

801032f0 <pipeclose>:
  return -1;
}

void
pipeclose(struct pipe *p, int writable)
{
801032f0:	55                   	push   %ebp
801032f1:	89 e5                	mov    %esp,%ebp
801032f3:	56                   	push   %esi
801032f4:	53                   	push   %ebx
801032f5:	8b 5d 08             	mov    0x8(%ebp),%ebx
801032f8:	8b 75 0c             	mov    0xc(%ebp),%esi
  acquire(&p->lock);
801032fb:	83 ec 0c             	sub    $0xc,%esp
801032fe:	53                   	push   %ebx
801032ff:	e8 4c 10 00 00       	call   80104350 <acquire>
  if(writable){
80103304:	83 c4 10             	add    $0x10,%esp
80103307:	85 f6                	test   %esi,%esi
80103309:	74 45                	je     80103350 <pipeclose+0x60>
    p->writeopen = 0;
    wakeup(&p->nread);
8010330b:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
80103311:	83 ec 0c             	sub    $0xc,%esp
void
pipeclose(struct pipe *p, int writable)
{
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
80103314:	c7 83 40 02 00 00 00 	movl   $0x0,0x240(%ebx)
8010331b:	00 00 00 
    wakeup(&p->nread);
8010331e:	50                   	push   %eax
8010331f:	e8 ec 0b 00 00       	call   80103f10 <wakeup>
80103324:	83 c4 10             	add    $0x10,%esp
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
80103327:	8b 93 3c 02 00 00    	mov    0x23c(%ebx),%edx
8010332d:	85 d2                	test   %edx,%edx
8010332f:	75 0a                	jne    8010333b <pipeclose+0x4b>
80103331:	8b 83 40 02 00 00    	mov    0x240(%ebx),%eax
80103337:	85 c0                	test   %eax,%eax
80103339:	74 35                	je     80103370 <pipeclose+0x80>
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
8010333b:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
8010333e:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103341:	5b                   	pop    %ebx
80103342:	5e                   	pop    %esi
80103343:	5d                   	pop    %ebp
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
  } else
    release(&p->lock);
80103344:	e9 b7 10 00 00       	jmp    80104400 <release>
80103349:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
    wakeup(&p->nwrite);
80103350:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
80103356:	83 ec 0c             	sub    $0xc,%esp
  acquire(&p->lock);
  if(writable){
    p->writeopen = 0;
    wakeup(&p->nread);
  } else {
    p->readopen = 0;
80103359:	c7 83 3c 02 00 00 00 	movl   $0x0,0x23c(%ebx)
80103360:	00 00 00 
    wakeup(&p->nwrite);
80103363:	50                   	push   %eax
80103364:	e8 a7 0b 00 00       	call   80103f10 <wakeup>
80103369:	83 c4 10             	add    $0x10,%esp
8010336c:	eb b9                	jmp    80103327 <pipeclose+0x37>
8010336e:	66 90                	xchg   %ax,%ax
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
80103370:	83 ec 0c             	sub    $0xc,%esp
80103373:	53                   	push   %ebx
80103374:	e8 87 10 00 00       	call   80104400 <release>
    kfree((char*)p);
80103379:	89 5d 08             	mov    %ebx,0x8(%ebp)
8010337c:	83 c4 10             	add    $0x10,%esp
  } else
    release(&p->lock);
}
8010337f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103382:	5b                   	pop    %ebx
80103383:	5e                   	pop    %esi
80103384:	5d                   	pop    %ebp
    p->readopen = 0;
    wakeup(&p->nwrite);
  }
  if(p->readopen == 0 && p->writeopen == 0){
    release(&p->lock);
    kfree((char*)p);
80103385:	e9 56 ef ff ff       	jmp    801022e0 <kfree>
8010338a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103390 <pipewrite>:
}

//PAGEBREAK: 40
int
pipewrite(struct pipe *p, char *addr, int n)
{
80103390:	55                   	push   %ebp
80103391:	89 e5                	mov    %esp,%ebp
80103393:	57                   	push   %edi
80103394:	56                   	push   %esi
80103395:	53                   	push   %ebx
80103396:	83 ec 28             	sub    $0x28,%esp
80103399:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int i;

  acquire(&p->lock);
8010339c:	53                   	push   %ebx
8010339d:	e8 ae 0f 00 00       	call   80104350 <acquire>
  for(i = 0; i < n; i++){
801033a2:	8b 45 10             	mov    0x10(%ebp),%eax
801033a5:	83 c4 10             	add    $0x10,%esp
801033a8:	85 c0                	test   %eax,%eax
801033aa:	0f 8e b9 00 00 00    	jle    80103469 <pipewrite+0xd9>
801033b0:	8b 4d 0c             	mov    0xc(%ebp),%ecx
801033b3:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
      if(p->readopen == 0 || myproc()->killed){
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033b9:	8d bb 34 02 00 00    	lea    0x234(%ebx),%edi
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033bf:	8d b3 38 02 00 00    	lea    0x238(%ebx),%esi
801033c5:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
801033c8:	03 4d 10             	add    0x10(%ebp),%ecx
801033cb:	89 4d e0             	mov    %ecx,-0x20(%ebp)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033ce:	8b 8b 34 02 00 00    	mov    0x234(%ebx),%ecx
801033d4:	8d 91 00 02 00 00    	lea    0x200(%ecx),%edx
801033da:	39 d0                	cmp    %edx,%eax
801033dc:	74 38                	je     80103416 <pipewrite+0x86>
801033de:	eb 59                	jmp    80103439 <pipewrite+0xa9>
      if(p->readopen == 0 || myproc()->killed){
801033e0:	e8 bb 03 00 00       	call   801037a0 <myproc>
801033e5:	8b 48 2c             	mov    0x2c(%eax),%ecx
801033e8:	85 c9                	test   %ecx,%ecx
801033ea:	75 34                	jne    80103420 <pipewrite+0x90>
        release(&p->lock);
        return -1;
      }
      wakeup(&p->nread);
801033ec:	83 ec 0c             	sub    $0xc,%esp
801033ef:	57                   	push   %edi
801033f0:	e8 1b 0b 00 00       	call   80103f10 <wakeup>
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
801033f5:	58                   	pop    %eax
801033f6:	5a                   	pop    %edx
801033f7:	53                   	push   %ebx
801033f8:	56                   	push   %esi
801033f9:	e8 52 09 00 00       	call   80103d50 <sleep>
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
801033fe:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
80103404:	8b 93 38 02 00 00    	mov    0x238(%ebx),%edx
8010340a:	83 c4 10             	add    $0x10,%esp
8010340d:	05 00 02 00 00       	add    $0x200,%eax
80103412:	39 c2                	cmp    %eax,%edx
80103414:	75 2a                	jne    80103440 <pipewrite+0xb0>
      if(p->readopen == 0 || myproc()->killed){
80103416:	8b 83 3c 02 00 00    	mov    0x23c(%ebx),%eax
8010341c:	85 c0                	test   %eax,%eax
8010341e:	75 c0                	jne    801033e0 <pipewrite+0x50>
        release(&p->lock);
80103420:	83 ec 0c             	sub    $0xc,%esp
80103423:	53                   	push   %ebx
80103424:	e8 d7 0f 00 00       	call   80104400 <release>
        return -1;
80103429:	83 c4 10             	add    $0x10,%esp
8010342c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
  release(&p->lock);
  return n;
}
80103431:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103434:	5b                   	pop    %ebx
80103435:	5e                   	pop    %esi
80103436:	5f                   	pop    %edi
80103437:	5d                   	pop    %ebp
80103438:	c3                   	ret    
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
    while(p->nwrite == p->nread + PIPESIZE){  //DOC: pipewrite-full
80103439:	89 c2                	mov    %eax,%edx
8010343b:	90                   	nop
8010343c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return -1;
      }
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
80103440:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103443:	8d 42 01             	lea    0x1(%edx),%eax
80103446:	83 45 e4 01          	addl   $0x1,-0x1c(%ebp)
8010344a:	81 e2 ff 01 00 00    	and    $0x1ff,%edx
80103450:	89 83 38 02 00 00    	mov    %eax,0x238(%ebx)
80103456:	0f b6 09             	movzbl (%ecx),%ecx
80103459:	88 4c 13 34          	mov    %cl,0x34(%ebx,%edx,1)
8010345d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
pipewrite(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  for(i = 0; i < n; i++){
80103460:	3b 4d e0             	cmp    -0x20(%ebp),%ecx
80103463:	0f 85 65 ff ff ff    	jne    801033ce <pipewrite+0x3e>
      wakeup(&p->nread);
      sleep(&p->nwrite, &p->lock);  //DOC: pipewrite-sleep
    }
    p->data[p->nwrite++ % PIPESIZE] = addr[i];
  }
  wakeup(&p->nread);  //DOC: pipewrite-wakeup1
80103469:	8d 83 34 02 00 00    	lea    0x234(%ebx),%eax
8010346f:	83 ec 0c             	sub    $0xc,%esp
80103472:	50                   	push   %eax
80103473:	e8 98 0a 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
80103478:	89 1c 24             	mov    %ebx,(%esp)
8010347b:	e8 80 0f 00 00       	call   80104400 <release>
  return n;
80103480:	83 c4 10             	add    $0x10,%esp
80103483:	8b 45 10             	mov    0x10(%ebp),%eax
80103486:	eb a9                	jmp    80103431 <pipewrite+0xa1>
80103488:	90                   	nop
80103489:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103490 <piperead>:
}

int
piperead(struct pipe *p, char *addr, int n)
{
80103490:	55                   	push   %ebp
80103491:	89 e5                	mov    %esp,%ebp
80103493:	57                   	push   %edi
80103494:	56                   	push   %esi
80103495:	53                   	push   %ebx
80103496:	83 ec 18             	sub    $0x18,%esp
80103499:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010349c:	8b 7d 0c             	mov    0xc(%ebp),%edi
  int i;

  acquire(&p->lock);
8010349f:	53                   	push   %ebx
801034a0:	e8 ab 0e 00 00       	call   80104350 <acquire>
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034a5:	83 c4 10             	add    $0x10,%esp
801034a8:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
801034ae:	39 83 38 02 00 00    	cmp    %eax,0x238(%ebx)
801034b4:	75 6a                	jne    80103520 <piperead+0x90>
801034b6:	8b b3 40 02 00 00    	mov    0x240(%ebx),%esi
801034bc:	85 f6                	test   %esi,%esi
801034be:	0f 84 cc 00 00 00    	je     80103590 <piperead+0x100>
    if(myproc()->killed){
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
801034c4:	8d b3 34 02 00 00    	lea    0x234(%ebx),%esi
801034ca:	eb 2d                	jmp    801034f9 <piperead+0x69>
801034cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801034d0:	83 ec 08             	sub    $0x8,%esp
801034d3:	53                   	push   %ebx
801034d4:	56                   	push   %esi
801034d5:	e8 76 08 00 00       	call   80103d50 <sleep>
piperead(struct pipe *p, char *addr, int n)
{
  int i;

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
801034da:	83 c4 10             	add    $0x10,%esp
801034dd:	8b 83 38 02 00 00    	mov    0x238(%ebx),%eax
801034e3:	39 83 34 02 00 00    	cmp    %eax,0x234(%ebx)
801034e9:	75 35                	jne    80103520 <piperead+0x90>
801034eb:	8b 93 40 02 00 00    	mov    0x240(%ebx),%edx
801034f1:	85 d2                	test   %edx,%edx
801034f3:	0f 84 97 00 00 00    	je     80103590 <piperead+0x100>
    if(myproc()->killed){
801034f9:	e8 a2 02 00 00       	call   801037a0 <myproc>
801034fe:	8b 48 2c             	mov    0x2c(%eax),%ecx
80103501:	85 c9                	test   %ecx,%ecx
80103503:	74 cb                	je     801034d0 <piperead+0x40>
      release(&p->lock);
80103505:	83 ec 0c             	sub    $0xc,%esp
80103508:	53                   	push   %ebx
80103509:	e8 f2 0e 00 00       	call   80104400 <release>
      return -1;
8010350e:	83 c4 10             	add    $0x10,%esp
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103511:	8d 65 f4             	lea    -0xc(%ebp),%esp

  acquire(&p->lock);
  while(p->nread == p->nwrite && p->writeopen){  //DOC: pipe-empty
    if(myproc()->killed){
      release(&p->lock);
      return -1;
80103514:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
  release(&p->lock);
  return i;
}
80103519:	5b                   	pop    %ebx
8010351a:	5e                   	pop    %esi
8010351b:	5f                   	pop    %edi
8010351c:	5d                   	pop    %ebp
8010351d:	c3                   	ret    
8010351e:	66 90                	xchg   %ax,%ax
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103520:	8b 45 10             	mov    0x10(%ebp),%eax
80103523:	85 c0                	test   %eax,%eax
80103525:	7e 69                	jle    80103590 <piperead+0x100>
    if(p->nread == p->nwrite)
80103527:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010352d:	31 c9                	xor    %ecx,%ecx
8010352f:	eb 15                	jmp    80103546 <piperead+0xb6>
80103531:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103538:	8b 83 34 02 00 00    	mov    0x234(%ebx),%eax
8010353e:	3b 83 38 02 00 00    	cmp    0x238(%ebx),%eax
80103544:	74 5a                	je     801035a0 <piperead+0x110>
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
80103546:	8d 70 01             	lea    0x1(%eax),%esi
80103549:	25 ff 01 00 00       	and    $0x1ff,%eax
8010354e:	89 b3 34 02 00 00    	mov    %esi,0x234(%ebx)
80103554:	0f b6 44 03 34       	movzbl 0x34(%ebx,%eax,1),%eax
80103559:	88 04 0f             	mov    %al,(%edi,%ecx,1)
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
8010355c:	83 c1 01             	add    $0x1,%ecx
8010355f:	39 4d 10             	cmp    %ecx,0x10(%ebp)
80103562:	75 d4                	jne    80103538 <piperead+0xa8>
    if(p->nread == p->nwrite)
      break;
    addr[i] = p->data[p->nread++ % PIPESIZE];
  }
  wakeup(&p->nwrite);  //DOC: piperead-wakeup
80103564:	8d 83 38 02 00 00    	lea    0x238(%ebx),%eax
8010356a:	83 ec 0c             	sub    $0xc,%esp
8010356d:	50                   	push   %eax
8010356e:	e8 9d 09 00 00       	call   80103f10 <wakeup>
  release(&p->lock);
80103573:	89 1c 24             	mov    %ebx,(%esp)
80103576:	e8 85 0e 00 00       	call   80104400 <release>
  return i;
8010357b:	8b 45 10             	mov    0x10(%ebp),%eax
8010357e:	83 c4 10             	add    $0x10,%esp
}
80103581:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103584:	5b                   	pop    %ebx
80103585:	5e                   	pop    %esi
80103586:	5f                   	pop    %edi
80103587:	5d                   	pop    %ebp
80103588:	c3                   	ret    
80103589:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&p->lock);
      return -1;
    }
    sleep(&p->nread, &p->lock); //DOC: piperead-sleep
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
80103590:	c7 45 10 00 00 00 00 	movl   $0x0,0x10(%ebp)
80103597:	eb cb                	jmp    80103564 <piperead+0xd4>
80103599:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801035a0:	89 4d 10             	mov    %ecx,0x10(%ebp)
801035a3:	eb bf                	jmp    80103564 <piperead+0xd4>
801035a5:	66 90                	xchg   %ax,%ax
801035a7:	66 90                	xchg   %ax,%ax
801035a9:	66 90                	xchg   %ax,%ax
801035ab:	66 90                	xchg   %ax,%ax
801035ad:	66 90                	xchg   %ax,%ax
801035af:	90                   	nop

801035b0 <allocproc>:
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b0:	55                   	push   %ebp
801035b1:	89 e5                	mov    %esp,%ebp
801035b3:	53                   	push   %ebx
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035b4:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
// If found, change state to EMBRYO and initialize
// state required to run in the kernel.
// Otherwise return 0.
static struct proc*
allocproc(void)
{
801035b9:	83 ec 10             	sub    $0x10,%esp
  struct proc *p;
  char *sp;

  acquire(&ptable.lock);
801035bc:	68 80 2d 11 80       	push   $0x80112d80
801035c1:	e8 8a 0d 00 00       	call   80104350 <acquire>
801035c6:	83 c4 10             	add    $0x10,%esp
801035c9:	eb 17                	jmp    801035e2 <allocproc+0x32>
801035cb:	90                   	nop
801035cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
801035d0:	81 c3 84 00 00 00    	add    $0x84,%ebx
801035d6:	81 fb b4 4e 11 80    	cmp    $0x80114eb4,%ebx
801035dc:	0f 84 86 00 00 00    	je     80103668 <allocproc+0xb8>
    if(p->state == UNUSED)
801035e2:	8b 43 14             	mov    0x14(%ebx),%eax
801035e5:	85 c0                	test   %eax,%eax
801035e7:	75 e7                	jne    801035d0 <allocproc+0x20>
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035e9:	a1 04 a0 10 80       	mov    0x8010a004,%eax

  release(&ptable.lock);
801035ee:	83 ec 0c             	sub    $0xc,%esp

  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
801035f1:	c7 43 14 01 00 00 00 	movl   $0x1,0x14(%ebx)
  p->pid = nextpid++;

  release(&ptable.lock);
801035f8:	68 80 2d 11 80       	push   $0x80112d80
  release(&ptable.lock);
  return 0;

found:
  p->state = EMBRYO;
  p->pid = nextpid++;
801035fd:	8d 50 01             	lea    0x1(%eax),%edx
80103600:	89 43 18             	mov    %eax,0x18(%ebx)
80103603:	89 15 04 a0 10 80    	mov    %edx,0x8010a004

  release(&ptable.lock);
80103609:	e8 f2 0d 00 00       	call   80104400 <release>

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
8010360e:	e8 7d ee ff ff       	call   80102490 <kalloc>
80103613:	83 c4 10             	add    $0x10,%esp
80103616:	85 c0                	test   %eax,%eax
80103618:	89 43 10             	mov    %eax,0x10(%ebx)
8010361b:	74 62                	je     8010367f <allocproc+0xcf>
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010361d:	8d 90 b4 0f 00 00    	lea    0xfb4(%eax),%edx
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103623:	83 ec 04             	sub    $0x4,%esp
  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
80103626:	05 9c 0f 00 00       	add    $0xf9c,%eax
    return 0;
  }
  sp = p->kstack + KSTACKSIZE;

  // Leave room for trap frame.
  sp -= sizeof *p->tf;
8010362b:	89 53 20             	mov    %edx,0x20(%ebx)
  p->tf = (struct trapframe*)sp;

  // Set up new context to start executing at forkret,
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;
8010362e:	c7 40 14 bf 57 10 80 	movl   $0x801057bf,0x14(%eax)

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
80103635:	6a 14                	push   $0x14
80103637:	6a 00                	push   $0x0
80103639:	50                   	push   %eax
  // which returns to trapret.
  sp -= 4;
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
8010363a:	89 43 24             	mov    %eax,0x24(%ebx)
  memset(p->context, 0, sizeof *p->context);
8010363d:	e8 0e 0e 00 00       	call   80104450 <memset>
  p->context->eip = (uint)forkret;
80103642:	8b 43 24             	mov    0x24(%ebx),%eax

  //Initialization of added data members
  p->printSys = 0; //Initially turning off printsys
  p->numCalls = 0; //Setting the current number of calls to 0

  return p;
80103645:	83 c4 10             	add    $0x10,%esp
  *(uint*)sp = (uint)trapret;

  sp -= sizeof *p->context;
  p->context = (struct context*)sp;
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;
80103648:	c7 40 10 90 36 10 80 	movl   $0x80103690,0x10(%eax)

  //Initialization of added data members
  p->printSys = 0; //Initially turning off printsys
8010364f:	c7 43 04 00 00 00 00 	movl   $0x0,0x4(%ebx)
  p->numCalls = 0; //Setting the current number of calls to 0

  return p;
80103656:	89 d8                	mov    %ebx,%eax
  memset(p->context, 0, sizeof *p->context);
  p->context->eip = (uint)forkret;

  //Initialization of added data members
  p->printSys = 0; //Initially turning off printsys
  p->numCalls = 0; //Setting the current number of calls to 0
80103658:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)

  return p;
}
8010365f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103662:	c9                   	leave  
80103663:	c3                   	ret    
80103664:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
    if(p->state == UNUSED)
      goto found;

  release(&ptable.lock);
80103668:	83 ec 0c             	sub    $0xc,%esp
8010366b:	68 80 2d 11 80       	push   $0x80112d80
80103670:	e8 8b 0d 00 00       	call   80104400 <release>
  return 0;
80103675:	83 c4 10             	add    $0x10,%esp
80103678:	31 c0                	xor    %eax,%eax
  //Initialization of added data members
  p->printSys = 0; //Initially turning off printsys
  p->numCalls = 0; //Setting the current number of calls to 0

  return p;
}
8010367a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010367d:	c9                   	leave  
8010367e:	c3                   	ret    

  release(&ptable.lock);

  // Allocate kernel stack.
  if((p->kstack = kalloc()) == 0){
    p->state = UNUSED;
8010367f:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
    return 0;
80103686:	eb d7                	jmp    8010365f <allocproc+0xaf>
80103688:	90                   	nop
80103689:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103690 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch here.  "Return" to user space.
void
forkret(void)
{
80103690:	55                   	push   %ebp
80103691:	89 e5                	mov    %esp,%ebp
80103693:	83 ec 14             	sub    $0x14,%esp
  static int first = 1;
  // Still holding ptable.lock from scheduler.
  release(&ptable.lock);
80103696:	68 80 2d 11 80       	push   $0x80112d80
8010369b:	e8 60 0d 00 00       	call   80104400 <release>

  if (first) {
801036a0:	a1 00 a0 10 80       	mov    0x8010a000,%eax
801036a5:	83 c4 10             	add    $0x10,%esp
801036a8:	85 c0                	test   %eax,%eax
801036aa:	75 04                	jne    801036b0 <forkret+0x20>
    iinit(ROOTDEV);
    initlog(ROOTDEV);
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036ac:	c9                   	leave  
801036ad:	c3                   	ret    
801036ae:	66 90                	xchg   %ax,%ax
  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
    iinit(ROOTDEV);
801036b0:	83 ec 0c             	sub    $0xc,%esp

  if (first) {
    // Some initialization functions must be run in the context
    // of a regular process (e.g., they call sleep), and thus cannot
    // be run from main().
    first = 0;
801036b3:	c7 05 00 a0 10 80 00 	movl   $0x0,0x8010a000
801036ba:	00 00 00 
    iinit(ROOTDEV);
801036bd:	6a 01                	push   $0x1
801036bf:	e8 ac dd ff ff       	call   80101470 <iinit>
    initlog(ROOTDEV);
801036c4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
801036cb:	e8 e0 f3 ff ff       	call   80102ab0 <initlog>
801036d0:	83 c4 10             	add    $0x10,%esp
  }

  // Return to "caller", actually trapret (see allocproc).
}
801036d3:	c9                   	leave  
801036d4:	c3                   	ret    
801036d5:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801036d9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801036e0 <pinit>:

static void wakeup1(void *chan);

void
pinit(void)
{
801036e0:	55                   	push   %ebp
801036e1:	89 e5                	mov    %esp,%ebp
801036e3:	83 ec 10             	sub    $0x10,%esp
  initlock(&ptable.lock, "ptable");
801036e6:	68 b5 75 10 80       	push   $0x801075b5
801036eb:	68 80 2d 11 80       	push   $0x80112d80
801036f0:	e8 fb 0a 00 00       	call   801041f0 <initlock>
}
801036f5:	83 c4 10             	add    $0x10,%esp
801036f8:	c9                   	leave  
801036f9:	c3                   	ret    
801036fa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103700 <mycpu>:

// Must be called with interrupts disabled to avoid the caller being
// rescheduled between reading lapicid and running through the loop.
struct cpu*
mycpu(void)
{
80103700:	55                   	push   %ebp
80103701:	89 e5                	mov    %esp,%ebp
80103703:	56                   	push   %esi
80103704:	53                   	push   %ebx

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103705:	9c                   	pushf  
80103706:	58                   	pop    %eax
  int apicid, i;
  
  if(readeflags()&FL_IF)
80103707:	f6 c4 02             	test   $0x2,%ah
8010370a:	75 5b                	jne    80103767 <mycpu+0x67>
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
8010370c:	e8 df ef ff ff       	call   801026f0 <lapicid>
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103711:	8b 35 60 2d 11 80    	mov    0x80112d60,%esi
80103717:	85 f6                	test   %esi,%esi
80103719:	7e 3f                	jle    8010375a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
8010371b:	0f b6 15 e0 27 11 80 	movzbl 0x801127e0,%edx
80103722:	39 d0                	cmp    %edx,%eax
80103724:	74 30                	je     80103756 <mycpu+0x56>
80103726:	b9 90 28 11 80       	mov    $0x80112890,%ecx
8010372b:	31 d2                	xor    %edx,%edx
8010372d:	8d 76 00             	lea    0x0(%esi),%esi
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103730:	83 c2 01             	add    $0x1,%edx
80103733:	39 f2                	cmp    %esi,%edx
80103735:	74 23                	je     8010375a <mycpu+0x5a>
    if (cpus[i].apicid == apicid)
80103737:	0f b6 19             	movzbl (%ecx),%ebx
8010373a:	81 c1 b0 00 00 00    	add    $0xb0,%ecx
80103740:	39 d8                	cmp    %ebx,%eax
80103742:	75 ec                	jne    80103730 <mycpu+0x30>
      return &cpus[i];
80103744:	69 c2 b0 00 00 00    	imul   $0xb0,%edx,%eax
  }
  panic("unknown apicid\n");
}
8010374a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010374d:	5b                   	pop    %ebx
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
    if (cpus[i].apicid == apicid)
      return &cpus[i];
8010374e:	05 e0 27 11 80       	add    $0x801127e0,%eax
  }
  panic("unknown apicid\n");
}
80103753:	5e                   	pop    %esi
80103754:	5d                   	pop    %ebp
80103755:	c3                   	ret    
    panic("mycpu called with interrupts enabled\n");
  
  apicid = lapicid();
  // APIC IDs are not guaranteed to be contiguous. Maybe we should have
  // a reverse map, or reserve a register to store &cpus[i].
  for (i = 0; i < ncpu; ++i) {
80103756:	31 d2                	xor    %edx,%edx
80103758:	eb ea                	jmp    80103744 <mycpu+0x44>
    if (cpus[i].apicid == apicid)
      return &cpus[i];
  }
  panic("unknown apicid\n");
8010375a:	83 ec 0c             	sub    $0xc,%esp
8010375d:	68 bc 75 10 80       	push   $0x801075bc
80103762:	e8 09 cc ff ff       	call   80100370 <panic>
mycpu(void)
{
  int apicid, i;
  
  if(readeflags()&FL_IF)
    panic("mycpu called with interrupts enabled\n");
80103767:	83 ec 0c             	sub    $0xc,%esp
8010376a:	68 98 76 10 80       	push   $0x80107698
8010376f:	e8 fc cb ff ff       	call   80100370 <panic>
80103774:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010377a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80103780 <cpuid>:
  initlock(&ptable.lock, "ptable");
}

// Must be called with interrupts disabled
int
cpuid() {
80103780:	55                   	push   %ebp
80103781:	89 e5                	mov    %esp,%ebp
80103783:	83 ec 08             	sub    $0x8,%esp
  return mycpu()-cpus;
80103786:	e8 75 ff ff ff       	call   80103700 <mycpu>
8010378b:	2d e0 27 11 80       	sub    $0x801127e0,%eax
}
80103790:	c9                   	leave  
}

// Must be called with interrupts disabled
int
cpuid() {
  return mycpu()-cpus;
80103791:	c1 f8 04             	sar    $0x4,%eax
80103794:	69 c0 a3 8b 2e ba    	imul   $0xba2e8ba3,%eax,%eax
}
8010379a:	c3                   	ret    
8010379b:	90                   	nop
8010379c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801037a0 <myproc>:
}

// Disable interrupts so that we are not rescheduled
// while reading proc from the cpu structure
struct proc*
myproc(void) {
801037a0:	55                   	push   %ebp
801037a1:	89 e5                	mov    %esp,%ebp
801037a3:	53                   	push   %ebx
801037a4:	83 ec 04             	sub    $0x4,%esp
  struct cpu *c;
  struct proc *p;
  pushcli();
801037a7:	e8 c4 0a 00 00       	call   80104270 <pushcli>
  c = mycpu();
801037ac:	e8 4f ff ff ff       	call   80103700 <mycpu>
  p = c->proc;
801037b1:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801037b7:	e8 f4 0a 00 00       	call   801042b0 <popcli>
  return p;
}
801037bc:	83 c4 04             	add    $0x4,%esp
801037bf:	89 d8                	mov    %ebx,%eax
801037c1:	5b                   	pop    %ebx
801037c2:	5d                   	pop    %ebp
801037c3:	c3                   	ret    
801037c4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801037ca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

801037d0 <userinit>:

//PAGEBREAK: 32
// Set up first user process.
void
userinit(void)
{
801037d0:	55                   	push   %ebp
801037d1:	89 e5                	mov    %esp,%ebp
801037d3:	53                   	push   %ebx
801037d4:	83 ec 04             	sub    $0x4,%esp
  struct proc *p;
  extern char _binary_initcode_start[], _binary_initcode_size[];

  p = allocproc();
801037d7:	e8 d4 fd ff ff       	call   801035b0 <allocproc>
801037dc:	89 c3                	mov    %eax,%ebx
  
  initproc = p;
801037de:	a3 18 a6 10 80       	mov    %eax,0x8010a618
  if((p->pgdir = setupkvm()) == 0)
801037e3:	e8 c8 35 00 00       	call   80106db0 <setupkvm>
801037e8:	85 c0                	test   %eax,%eax
801037ea:	89 43 0c             	mov    %eax,0xc(%ebx)
801037ed:	0f 84 bd 00 00 00    	je     801038b0 <userinit+0xe0>
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
801037f3:	83 ec 04             	sub    $0x4,%esp
801037f6:	68 2c 00 00 00       	push   $0x2c
801037fb:	68 c0 a4 10 80       	push   $0x8010a4c0
80103800:	50                   	push   %eax
80103801:	e8 ba 32 00 00       	call   80106ac0 <inituvm>
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
80103806:	83 c4 0c             	add    $0xc,%esp
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
80103809:	c7 03 00 10 00 00    	movl   $0x1000,(%ebx)
  memset(p->tf, 0, sizeof(*p->tf));
8010380f:	6a 4c                	push   $0x4c
80103811:	6a 00                	push   $0x0
80103813:	ff 73 20             	pushl  0x20(%ebx)
80103816:	e8 35 0c 00 00       	call   80104450 <memset>
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010381b:	8b 43 20             	mov    0x20(%ebx),%eax
8010381e:	ba 1b 00 00 00       	mov    $0x1b,%edx
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
80103823:	b9 23 00 00 00       	mov    $0x23,%ecx
  p->tf->ss = p->tf->ds;
  p->tf->eflags = FL_IF;
  p->tf->esp = PGSIZE;
  p->tf->eip = 0;  // beginning of initcode.S

  safestrcpy(p->name, "initcode", sizeof(p->name));
80103828:	83 c4 0c             	add    $0xc,%esp
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
  inituvm(p->pgdir, _binary_initcode_start, (int)_binary_initcode_size);
  p->sz = PGSIZE;
  memset(p->tf, 0, sizeof(*p->tf));
  p->tf->cs = (SEG_UCODE << 3) | DPL_USER;
8010382b:	66 89 50 3c          	mov    %dx,0x3c(%eax)
  p->tf->ds = (SEG_UDATA << 3) | DPL_USER;
8010382f:	8b 43 20             	mov    0x20(%ebx),%eax
80103832:	66 89 48 2c          	mov    %cx,0x2c(%eax)
  p->tf->es = p->tf->ds;
80103836:	8b 43 20             	mov    0x20(%ebx),%eax
80103839:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
8010383d:	66 89 50 28          	mov    %dx,0x28(%eax)
  p->tf->ss = p->tf->ds;
80103841:	8b 43 20             	mov    0x20(%ebx),%eax
80103844:	0f b7 50 2c          	movzwl 0x2c(%eax),%edx
80103848:	66 89 50 48          	mov    %dx,0x48(%eax)
  p->tf->eflags = FL_IF;
8010384c:	8b 43 20             	mov    0x20(%ebx),%eax
8010384f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)
  p->tf->esp = PGSIZE;
80103856:	8b 43 20             	mov    0x20(%ebx),%eax
80103859:	c7 40 44 00 10 00 00 	movl   $0x1000,0x44(%eax)
  p->tf->eip = 0;  // beginning of initcode.S
80103860:	8b 43 20             	mov    0x20(%ebx),%eax
80103863:	c7 40 38 00 00 00 00 	movl   $0x0,0x38(%eax)

  safestrcpy(p->name, "initcode", sizeof(p->name));
8010386a:	8d 43 74             	lea    0x74(%ebx),%eax
8010386d:	6a 10                	push   $0x10
8010386f:	68 e5 75 10 80       	push   $0x801075e5
80103874:	50                   	push   %eax
80103875:	e8 d6 0d 00 00       	call   80104650 <safestrcpy>
  p->cwd = namei("/");
8010387a:	c7 04 24 ee 75 10 80 	movl   $0x801075ee,(%esp)
80103881:	e8 3a e6 ff ff       	call   80101ec0 <namei>
80103886:	89 43 70             	mov    %eax,0x70(%ebx)

  // this assignment to p->state lets other cores
  // run this process. the acquire forces the above
  // writes to be visible, and the lock is also needed
  // because the assignment might not be atomic.
  acquire(&ptable.lock);
80103889:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103890:	e8 bb 0a 00 00       	call   80104350 <acquire>

  p->state = RUNNABLE;
80103895:	c7 43 14 03 00 00 00 	movl   $0x3,0x14(%ebx)

  release(&ptable.lock);
8010389c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
801038a3:	e8 58 0b 00 00       	call   80104400 <release>
}
801038a8:	83 c4 10             	add    $0x10,%esp
801038ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801038ae:	c9                   	leave  
801038af:	c3                   	ret    

  p = allocproc();
  
  initproc = p;
  if((p->pgdir = setupkvm()) == 0)
    panic("userinit: out of memory?");
801038b0:	83 ec 0c             	sub    $0xc,%esp
801038b3:	68 cc 75 10 80       	push   $0x801075cc
801038b8:	e8 b3 ca ff ff       	call   80100370 <panic>
801038bd:	8d 76 00             	lea    0x0(%esi),%esi

801038c0 <growproc>:

// Grow current process's memory by n bytes.
// Return 0 on success, -1 on failure.
int
growproc(int n)
{
801038c0:	55                   	push   %ebp
801038c1:	89 e5                	mov    %esp,%ebp
801038c3:	56                   	push   %esi
801038c4:	53                   	push   %ebx
801038c5:	8b 75 08             	mov    0x8(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
801038c8:	e8 a3 09 00 00       	call   80104270 <pushcli>
  c = mycpu();
801038cd:	e8 2e fe ff ff       	call   80103700 <mycpu>
  p = c->proc;
801038d2:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
801038d8:	e8 d3 09 00 00       	call   801042b0 <popcli>
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
801038dd:	83 fe 00             	cmp    $0x0,%esi
growproc(int n)
{
  uint sz;
  struct proc *curproc = myproc();

  sz = curproc->sz;
801038e0:	8b 03                	mov    (%ebx),%eax
  if(n > 0){
801038e2:	7e 34                	jle    80103918 <growproc+0x58>
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
801038e4:	83 ec 04             	sub    $0x4,%esp
801038e7:	01 c6                	add    %eax,%esi
801038e9:	56                   	push   %esi
801038ea:	50                   	push   %eax
801038eb:	ff 73 0c             	pushl  0xc(%ebx)
801038ee:	e8 0d 33 00 00       	call   80106c00 <allocuvm>
801038f3:	83 c4 10             	add    $0x10,%esp
801038f6:	85 c0                	test   %eax,%eax
801038f8:	74 36                	je     80103930 <growproc+0x70>
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
  switchuvm(curproc);
801038fa:	83 ec 0c             	sub    $0xc,%esp
      return -1;
  } else if(n < 0){
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  }
  curproc->sz = sz;
801038fd:	89 03                	mov    %eax,(%ebx)
  switchuvm(curproc);
801038ff:	53                   	push   %ebx
80103900:	e8 ab 30 00 00       	call   801069b0 <switchuvm>
  return 0;
80103905:	83 c4 10             	add    $0x10,%esp
80103908:	31 c0                	xor    %eax,%eax
}
8010390a:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010390d:	5b                   	pop    %ebx
8010390e:	5e                   	pop    %esi
8010390f:	5d                   	pop    %ebp
80103910:	c3                   	ret    
80103911:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
  } else if(n < 0){
80103918:	74 e0                	je     801038fa <growproc+0x3a>
    if((sz = deallocuvm(curproc->pgdir, sz, sz + n)) == 0)
8010391a:	83 ec 04             	sub    $0x4,%esp
8010391d:	01 c6                	add    %eax,%esi
8010391f:	56                   	push   %esi
80103920:	50                   	push   %eax
80103921:	ff 73 0c             	pushl  0xc(%ebx)
80103924:	e8 d7 33 00 00       	call   80106d00 <deallocuvm>
80103929:	83 c4 10             	add    $0x10,%esp
8010392c:	85 c0                	test   %eax,%eax
8010392e:	75 ca                	jne    801038fa <growproc+0x3a>
  struct proc *curproc = myproc();

  sz = curproc->sz;
  if(n > 0){
    if((sz = allocuvm(curproc->pgdir, sz, sz + n)) == 0)
      return -1;
80103930:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103935:	eb d3                	jmp    8010390a <growproc+0x4a>
80103937:	89 f6                	mov    %esi,%esi
80103939:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103940 <fork>:
// Create a new process copying p as the parent.
// Sets up stack to return as if from system call.
// Caller must set state of returned proc to RUNNABLE.
int
fork(void)
{
80103940:	55                   	push   %ebp
80103941:	89 e5                	mov    %esp,%ebp
80103943:	57                   	push   %edi
80103944:	56                   	push   %esi
80103945:	53                   	push   %ebx
80103946:	83 ec 1c             	sub    $0x1c,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103949:	e8 22 09 00 00       	call   80104270 <pushcli>
  c = mycpu();
8010394e:	e8 ad fd ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103953:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103959:	e8 52 09 00 00       	call   801042b0 <popcli>
  int i, pid;
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
8010395e:	e8 4d fc ff ff       	call   801035b0 <allocproc>
80103963:	85 c0                	test   %eax,%eax
80103965:	89 c7                	mov    %eax,%edi
80103967:	89 45 e4             	mov    %eax,-0x1c(%ebp)
8010396a:	0f 84 b5 00 00 00    	je     80103a25 <fork+0xe5>
    return -1;
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
80103970:	83 ec 08             	sub    $0x8,%esp
80103973:	ff 33                	pushl  (%ebx)
80103975:	ff 73 0c             	pushl  0xc(%ebx)
80103978:	e8 03 35 00 00       	call   80106e80 <copyuvm>
8010397d:	83 c4 10             	add    $0x10,%esp
80103980:	85 c0                	test   %eax,%eax
80103982:	89 47 0c             	mov    %eax,0xc(%edi)
80103985:	0f 84 a1 00 00 00    	je     80103a2c <fork+0xec>
    kfree(np->kstack);
    np->kstack = 0;
    np->state = UNUSED;
    return -1;
  }
  np->sz = curproc->sz;
8010398b:	8b 03                	mov    (%ebx),%eax
8010398d:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80103990:	89 01                	mov    %eax,(%ecx)
  np->parent = curproc;
80103992:	89 59 1c             	mov    %ebx,0x1c(%ecx)
  *np->tf = *curproc->tf;
80103995:	89 c8                	mov    %ecx,%eax
80103997:	8b 79 20             	mov    0x20(%ecx),%edi
8010399a:	8b 73 20             	mov    0x20(%ebx),%esi
8010399d:	b9 13 00 00 00       	mov    $0x13,%ecx
801039a2:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039a4:	31 f6                	xor    %esi,%esi
  np->sz = curproc->sz;
  np->parent = curproc;
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;
801039a6:	8b 40 20             	mov    0x20(%eax),%eax
801039a9:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
801039b0:	8b 44 b3 30          	mov    0x30(%ebx,%esi,4),%eax
801039b4:	85 c0                	test   %eax,%eax
801039b6:	74 13                	je     801039cb <fork+0x8b>
      np->ofile[i] = filedup(curproc->ofile[i]);
801039b8:	83 ec 0c             	sub    $0xc,%esp
801039bb:	50                   	push   %eax
801039bc:	e8 1f d4 ff ff       	call   80100de0 <filedup>
801039c1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
801039c4:	83 c4 10             	add    $0x10,%esp
801039c7:	89 44 b2 30          	mov    %eax,0x30(%edx,%esi,4)
  *np->tf = *curproc->tf;

  // Clear %eax so that fork returns 0 in the child.
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
801039cb:	83 c6 01             	add    $0x1,%esi
801039ce:	83 fe 10             	cmp    $0x10,%esi
801039d1:	75 dd                	jne    801039b0 <fork+0x70>
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039d3:	83 ec 0c             	sub    $0xc,%esp
801039d6:	ff 73 70             	pushl  0x70(%ebx)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039d9:	83 c3 74             	add    $0x74,%ebx
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039dc:	e8 5f dc ff ff       	call   80101640 <idup>
801039e1:	8b 7d e4             	mov    -0x1c(%ebp),%edi

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039e4:	83 c4 0c             	add    $0xc,%esp
  np->tf->eax = 0;

  for(i = 0; i < NOFILE; i++)
    if(curproc->ofile[i])
      np->ofile[i] = filedup(curproc->ofile[i]);
  np->cwd = idup(curproc->cwd);
801039e7:	89 47 70             	mov    %eax,0x70(%edi)

  safestrcpy(np->name, curproc->name, sizeof(curproc->name));
801039ea:	8d 47 74             	lea    0x74(%edi),%eax
801039ed:	6a 10                	push   $0x10
801039ef:	53                   	push   %ebx
801039f0:	50                   	push   %eax
801039f1:	e8 5a 0c 00 00       	call   80104650 <safestrcpy>

  pid = np->pid;
801039f6:	8b 5f 18             	mov    0x18(%edi),%ebx

  acquire(&ptable.lock);
801039f9:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103a00:	e8 4b 09 00 00       	call   80104350 <acquire>

  np->state = RUNNABLE;
80103a05:	c7 47 14 03 00 00 00 	movl   $0x3,0x14(%edi)

  release(&ptable.lock);
80103a0c:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103a13:	e8 e8 09 00 00       	call   80104400 <release>

  return pid;
80103a18:	83 c4 10             	add    $0x10,%esp
80103a1b:	89 d8                	mov    %ebx,%eax
}
80103a1d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103a20:	5b                   	pop    %ebx
80103a21:	5e                   	pop    %esi
80103a22:	5f                   	pop    %edi
80103a23:	5d                   	pop    %ebp
80103a24:	c3                   	ret    
  struct proc *np;
  struct proc *curproc = myproc();

  // Allocate process.
  if((np = allocproc()) == 0){
    return -1;
80103a25:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a2a:	eb f1                	jmp    80103a1d <fork+0xdd>
  }

  // Copy process state from proc.
  if((np->pgdir = copyuvm(curproc->pgdir, curproc->sz)) == 0){
    kfree(np->kstack);
80103a2c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
80103a2f:	83 ec 0c             	sub    $0xc,%esp
80103a32:	ff 77 10             	pushl  0x10(%edi)
80103a35:	e8 a6 e8 ff ff       	call   801022e0 <kfree>
    np->kstack = 0;
80103a3a:	c7 47 10 00 00 00 00 	movl   $0x0,0x10(%edi)
    np->state = UNUSED;
80103a41:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
    return -1;
80103a48:	83 c4 10             	add    $0x10,%esp
80103a4b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80103a50:	eb cb                	jmp    80103a1d <fork+0xdd>
80103a52:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103a60 <scheduler>:
//  - swtch to start running that process
//  - eventually that process transfers control
//      via swtch back to the scheduler.
void
scheduler(void)
{
80103a60:	55                   	push   %ebp
80103a61:	89 e5                	mov    %esp,%ebp
80103a63:	57                   	push   %edi
80103a64:	56                   	push   %esi
80103a65:	53                   	push   %ebx
80103a66:	83 ec 0c             	sub    $0xc,%esp
  struct proc *p;
  struct cpu *c = mycpu();
80103a69:	e8 92 fc ff ff       	call   80103700 <mycpu>
80103a6e:	8d 78 04             	lea    0x4(%eax),%edi
80103a71:	89 c6                	mov    %eax,%esi
  c->proc = 0;
80103a73:	c7 80 ac 00 00 00 00 	movl   $0x0,0xac(%eax)
80103a7a:	00 00 00 
80103a7d:	8d 76 00             	lea    0x0(%esi),%esi
}

static inline void
sti(void)
{
  asm volatile("sti");
80103a80:	fb                   	sti    
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a81:	83 ec 0c             	sub    $0xc,%esp
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103a84:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
  for(;;){
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
80103a89:	68 80 2d 11 80       	push   $0x80112d80
80103a8e:	e8 bd 08 00 00       	call   80104350 <acquire>
80103a93:	83 c4 10             	add    $0x10,%esp
80103a96:	eb 16                	jmp    80103aae <scheduler+0x4e>
80103a98:	90                   	nop
80103a99:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103aa0:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103aa6:	81 fb b4 4e 11 80    	cmp    $0x80114eb4,%ebx
80103aac:	74 4a                	je     80103af8 <scheduler+0x98>
      if(p->state != RUNNABLE)
80103aae:	83 7b 14 03          	cmpl   $0x3,0x14(%ebx)
80103ab2:	75 ec                	jne    80103aa0 <scheduler+0x40>

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ab4:	83 ec 0c             	sub    $0xc,%esp
        continue;

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
80103ab7:	89 9e ac 00 00 00    	mov    %ebx,0xac(%esi)
      switchuvm(p);
80103abd:	53                   	push   %ebx
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103abe:	81 c3 84 00 00 00    	add    $0x84,%ebx

      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
80103ac4:	e8 e7 2e 00 00       	call   801069b0 <switchuvm>
      p->state = RUNNING;

      swtch(&(c->scheduler), p->context);
80103ac9:	58                   	pop    %eax
80103aca:	5a                   	pop    %edx
80103acb:	ff 73 a0             	pushl  -0x60(%ebx)
80103ace:	57                   	push   %edi
      // Switch to chosen process.  It is the process's job
      // to release ptable.lock and then reacquire it
      // before jumping back to us.
      c->proc = p;
      switchuvm(p);
      p->state = RUNNING;
80103acf:	c7 43 90 04 00 00 00 	movl   $0x4,-0x70(%ebx)

      swtch(&(c->scheduler), p->context);
80103ad6:	e8 d0 0b 00 00       	call   801046ab <swtch>
      switchkvm();
80103adb:	e8 b0 2e 00 00       	call   80106990 <switchkvm>

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ae0:	83 c4 10             	add    $0x10,%esp
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103ae3:	81 fb b4 4e 11 80    	cmp    $0x80114eb4,%ebx
      swtch(&(c->scheduler), p->context);
      switchkvm();

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
80103ae9:	c7 86 ac 00 00 00 00 	movl   $0x0,0xac(%esi)
80103af0:	00 00 00 
    // Enable interrupts on this processor.
    sti();

    // Loop over process table looking for process to run.
    acquire(&ptable.lock);
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103af3:	75 b9                	jne    80103aae <scheduler+0x4e>
80103af5:	8d 76 00             	lea    0x0(%esi),%esi

      // Process is done running for now.
      // It should have changed its p->state before coming back.
      c->proc = 0;
    }
    release(&ptable.lock);
80103af8:	83 ec 0c             	sub    $0xc,%esp
80103afb:	68 80 2d 11 80       	push   $0x80112d80
80103b00:	e8 fb 08 00 00       	call   80104400 <release>

  }
80103b05:	83 c4 10             	add    $0x10,%esp
80103b08:	e9 73 ff ff ff       	jmp    80103a80 <scheduler+0x20>
80103b0d:	8d 76 00             	lea    0x0(%esi),%esi

80103b10 <sched>:
// be proc->intena and proc->ncli, but that would
// break in the few places where a lock is held but
// there's no process.
void
sched(void)
{
80103b10:	55                   	push   %ebp
80103b11:	89 e5                	mov    %esp,%ebp
80103b13:	56                   	push   %esi
80103b14:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103b15:	e8 56 07 00 00       	call   80104270 <pushcli>
  c = mycpu();
80103b1a:	e8 e1 fb ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103b1f:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103b25:	e8 86 07 00 00       	call   801042b0 <popcli>
sched(void)
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
80103b2a:	83 ec 0c             	sub    $0xc,%esp
80103b2d:	68 80 2d 11 80       	push   $0x80112d80
80103b32:	e8 e9 07 00 00       	call   80104320 <holding>
80103b37:	83 c4 10             	add    $0x10,%esp
80103b3a:	85 c0                	test   %eax,%eax
80103b3c:	74 4f                	je     80103b8d <sched+0x7d>
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
80103b3e:	e8 bd fb ff ff       	call   80103700 <mycpu>
80103b43:	83 b8 a4 00 00 00 01 	cmpl   $0x1,0xa4(%eax)
80103b4a:	75 68                	jne    80103bb4 <sched+0xa4>
    panic("sched locks");
  if(p->state == RUNNING)
80103b4c:	83 7b 14 04          	cmpl   $0x4,0x14(%ebx)
80103b50:	74 55                	je     80103ba7 <sched+0x97>

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
80103b52:	9c                   	pushf  
80103b53:	58                   	pop    %eax
    panic("sched running");
  if(readeflags()&FL_IF)
80103b54:	f6 c4 02             	test   $0x2,%ah
80103b57:	75 41                	jne    80103b9a <sched+0x8a>
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b59:	e8 a2 fb ff ff       	call   80103700 <mycpu>
  swtch(&p->context, mycpu()->scheduler);
80103b5e:	83 c3 24             	add    $0x24,%ebx
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
80103b61:	8b b0 a8 00 00 00    	mov    0xa8(%eax),%esi
  swtch(&p->context, mycpu()->scheduler);
80103b67:	e8 94 fb ff ff       	call   80103700 <mycpu>
80103b6c:	83 ec 08             	sub    $0x8,%esp
80103b6f:	ff 70 04             	pushl  0x4(%eax)
80103b72:	53                   	push   %ebx
80103b73:	e8 33 0b 00 00       	call   801046ab <swtch>
  mycpu()->intena = intena;
80103b78:	e8 83 fb ff ff       	call   80103700 <mycpu>
}
80103b7d:	83 c4 10             	add    $0x10,%esp
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
  intena = mycpu()->intena;
  swtch(&p->context, mycpu()->scheduler);
  mycpu()->intena = intena;
80103b80:	89 b0 a8 00 00 00    	mov    %esi,0xa8(%eax)
}
80103b86:	8d 65 f8             	lea    -0x8(%ebp),%esp
80103b89:	5b                   	pop    %ebx
80103b8a:	5e                   	pop    %esi
80103b8b:	5d                   	pop    %ebp
80103b8c:	c3                   	ret    
{
  int intena;
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
80103b8d:	83 ec 0c             	sub    $0xc,%esp
80103b90:	68 f0 75 10 80       	push   $0x801075f0
80103b95:	e8 d6 c7 ff ff       	call   80100370 <panic>
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
  if(readeflags()&FL_IF)
    panic("sched interruptible");
80103b9a:	83 ec 0c             	sub    $0xc,%esp
80103b9d:	68 1c 76 10 80       	push   $0x8010761c
80103ba2:	e8 c9 c7 ff ff       	call   80100370 <panic>
  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
  if(p->state == RUNNING)
    panic("sched running");
80103ba7:	83 ec 0c             	sub    $0xc,%esp
80103baa:	68 0e 76 10 80       	push   $0x8010760e
80103baf:	e8 bc c7 ff ff       	call   80100370 <panic>
  struct proc *p = myproc();

  if(!holding(&ptable.lock))
    panic("sched ptable.lock");
  if(mycpu()->ncli != 1)
    panic("sched locks");
80103bb4:	83 ec 0c             	sub    $0xc,%esp
80103bb7:	68 02 76 10 80       	push   $0x80107602
80103bbc:	e8 af c7 ff ff       	call   80100370 <panic>
80103bc1:	eb 0d                	jmp    80103bd0 <exit>
80103bc3:	90                   	nop
80103bc4:	90                   	nop
80103bc5:	90                   	nop
80103bc6:	90                   	nop
80103bc7:	90                   	nop
80103bc8:	90                   	nop
80103bc9:	90                   	nop
80103bca:	90                   	nop
80103bcb:	90                   	nop
80103bcc:	90                   	nop
80103bcd:	90                   	nop
80103bce:	90                   	nop
80103bcf:	90                   	nop

80103bd0 <exit>:
// Exit the current process.  Does not return.
// An exited process remains in the zombie state
// until its parent calls wait() to find out it exited.
void
exit(void)
{
80103bd0:	55                   	push   %ebp
80103bd1:	89 e5                	mov    %esp,%ebp
80103bd3:	57                   	push   %edi
80103bd4:	56                   	push   %esi
80103bd5:	53                   	push   %ebx
80103bd6:	83 ec 0c             	sub    $0xc,%esp
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103bd9:	e8 92 06 00 00       	call   80104270 <pushcli>
  c = mycpu();
80103bde:	e8 1d fb ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103be3:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103be9:	e8 c2 06 00 00       	call   801042b0 <popcli>
{
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
80103bee:	39 35 18 a6 10 80    	cmp    %esi,0x8010a618
80103bf4:	8d 5e 30             	lea    0x30(%esi),%ebx
80103bf7:	8d 7e 70             	lea    0x70(%esi),%edi
80103bfa:	0f 84 f1 00 00 00    	je     80103cf1 <exit+0x121>
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd]){
80103c00:	8b 03                	mov    (%ebx),%eax
80103c02:	85 c0                	test   %eax,%eax
80103c04:	74 12                	je     80103c18 <exit+0x48>
      fileclose(curproc->ofile[fd]);
80103c06:	83 ec 0c             	sub    $0xc,%esp
80103c09:	50                   	push   %eax
80103c0a:	e8 21 d2 ff ff       	call   80100e30 <fileclose>
      curproc->ofile[fd] = 0;
80103c0f:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
80103c15:	83 c4 10             	add    $0x10,%esp
80103c18:	83 c3 04             	add    $0x4,%ebx

  if(curproc == initproc)
    panic("init exiting");

  // Close all open files.
  for(fd = 0; fd < NOFILE; fd++){
80103c1b:	39 df                	cmp    %ebx,%edi
80103c1d:	75 e1                	jne    80103c00 <exit+0x30>
      fileclose(curproc->ofile[fd]);
      curproc->ofile[fd] = 0;
    }
  }

  begin_op();
80103c1f:	e8 2c ef ff ff       	call   80102b50 <begin_op>
  iput(curproc->cwd);
80103c24:	83 ec 0c             	sub    $0xc,%esp
80103c27:	ff 76 70             	pushl  0x70(%esi)
80103c2a:	e8 71 db ff ff       	call   801017a0 <iput>
  end_op();
80103c2f:	e8 8c ef ff ff       	call   80102bc0 <end_op>
  curproc->cwd = 0;
80103c34:	c7 46 70 00 00 00 00 	movl   $0x0,0x70(%esi)

  acquire(&ptable.lock);
80103c3b:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103c42:	e8 09 07 00 00       	call   80104350 <acquire>

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);
80103c47:	8b 56 1c             	mov    0x1c(%esi),%edx
80103c4a:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c4d:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80103c52:	eb 10                	jmp    80103c64 <exit+0x94>
80103c54:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103c58:	05 84 00 00 00       	add    $0x84,%eax
80103c5d:	3d b4 4e 11 80       	cmp    $0x80114eb4,%eax
80103c62:	74 1e                	je     80103c82 <exit+0xb2>
    if(p->state == SLEEPING && p->chan == chan)
80103c64:	83 78 14 02          	cmpl   $0x2,0x14(%eax)
80103c68:	75 ee                	jne    80103c58 <exit+0x88>
80103c6a:	3b 50 28             	cmp    0x28(%eax),%edx
80103c6d:	75 e9                	jne    80103c58 <exit+0x88>
      p->state = RUNNABLE;
80103c6f:	c7 40 14 03 00 00 00 	movl   $0x3,0x14(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103c76:	05 84 00 00 00       	add    $0x84,%eax
80103c7b:	3d b4 4e 11 80       	cmp    $0x80114eb4,%eax
80103c80:	75 e2                	jne    80103c64 <exit+0x94>
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103c82:	8b 0d 18 a6 10 80    	mov    0x8010a618,%ecx
80103c88:	ba b4 2d 11 80       	mov    $0x80112db4,%edx
80103c8d:	eb 0f                	jmp    80103c9e <exit+0xce>
80103c8f:	90                   	nop

  // Parent might be sleeping in wait().
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103c90:	81 c2 84 00 00 00    	add    $0x84,%edx
80103c96:	81 fa b4 4e 11 80    	cmp    $0x80114eb4,%edx
80103c9c:	74 3a                	je     80103cd8 <exit+0x108>
    if(p->parent == curproc){
80103c9e:	39 72 1c             	cmp    %esi,0x1c(%edx)
80103ca1:	75 ed                	jne    80103c90 <exit+0xc0>
      p->parent = initproc;
      if(p->state == ZOMBIE)
80103ca3:	83 7a 14 05          	cmpl   $0x5,0x14(%edx)
  wakeup1(curproc->parent);

  // Pass abandoned children to init.
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->parent == curproc){
      p->parent = initproc;
80103ca7:	89 4a 1c             	mov    %ecx,0x1c(%edx)
      if(p->state == ZOMBIE)
80103caa:	75 e4                	jne    80103c90 <exit+0xc0>
80103cac:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80103cb1:	eb 11                	jmp    80103cc4 <exit+0xf4>
80103cb3:	90                   	nop
80103cb4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103cb8:	05 84 00 00 00       	add    $0x84,%eax
80103cbd:	3d b4 4e 11 80       	cmp    $0x80114eb4,%eax
80103cc2:	74 cc                	je     80103c90 <exit+0xc0>
    if(p->state == SLEEPING && p->chan == chan)
80103cc4:	83 78 14 02          	cmpl   $0x2,0x14(%eax)
80103cc8:	75 ee                	jne    80103cb8 <exit+0xe8>
80103cca:	3b 48 28             	cmp    0x28(%eax),%ecx
80103ccd:	75 e9                	jne    80103cb8 <exit+0xe8>
      p->state = RUNNABLE;
80103ccf:	c7 40 14 03 00 00 00 	movl   $0x3,0x14(%eax)
80103cd6:	eb e0                	jmp    80103cb8 <exit+0xe8>
        wakeup1(initproc);
    }
  }

  // Jump into the scheduler, never to return.
  curproc->state = ZOMBIE;
80103cd8:	c7 46 14 05 00 00 00 	movl   $0x5,0x14(%esi)
  sched();
80103cdf:	e8 2c fe ff ff       	call   80103b10 <sched>
  panic("zombie exit");
80103ce4:	83 ec 0c             	sub    $0xc,%esp
80103ce7:	68 3d 76 10 80       	push   $0x8010763d
80103cec:	e8 7f c6 ff ff       	call   80100370 <panic>
  struct proc *curproc = myproc();
  struct proc *p;
  int fd;

  if(curproc == initproc)
    panic("init exiting");
80103cf1:	83 ec 0c             	sub    $0xc,%esp
80103cf4:	68 30 76 10 80       	push   $0x80107630
80103cf9:	e8 72 c6 ff ff       	call   80100370 <panic>
80103cfe:	66 90                	xchg   %ax,%ax

80103d00 <yield>:
}

// Give up the CPU for one scheduling round.
void
yield(void)
{
80103d00:	55                   	push   %ebp
80103d01:	89 e5                	mov    %esp,%ebp
80103d03:	53                   	push   %ebx
80103d04:	83 ec 10             	sub    $0x10,%esp
  acquire(&ptable.lock);  //DOC: yieldlock
80103d07:	68 80 2d 11 80       	push   $0x80112d80
80103d0c:	e8 3f 06 00 00       	call   80104350 <acquire>
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d11:	e8 5a 05 00 00       	call   80104270 <pushcli>
  c = mycpu();
80103d16:	e8 e5 f9 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103d1b:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d21:	e8 8a 05 00 00       	call   801042b0 <popcli>
// Give up the CPU for one scheduling round.
void
yield(void)
{
  acquire(&ptable.lock);  //DOC: yieldlock
  myproc()->state = RUNNABLE;
80103d26:	c7 43 14 03 00 00 00 	movl   $0x3,0x14(%ebx)
  sched();
80103d2d:	e8 de fd ff ff       	call   80103b10 <sched>
  release(&ptable.lock);
80103d32:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103d39:	e8 c2 06 00 00       	call   80104400 <release>
}
80103d3e:	83 c4 10             	add    $0x10,%esp
80103d41:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103d44:	c9                   	leave  
80103d45:	c3                   	ret    
80103d46:	8d 76 00             	lea    0x0(%esi),%esi
80103d49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80103d50 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
80103d50:	55                   	push   %ebp
80103d51:	89 e5                	mov    %esp,%ebp
80103d53:	57                   	push   %edi
80103d54:	56                   	push   %esi
80103d55:	53                   	push   %ebx
80103d56:	83 ec 0c             	sub    $0xc,%esp
80103d59:	8b 7d 08             	mov    0x8(%ebp),%edi
80103d5c:	8b 75 0c             	mov    0xc(%ebp),%esi
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103d5f:	e8 0c 05 00 00       	call   80104270 <pushcli>
  c = mycpu();
80103d64:	e8 97 f9 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103d69:	8b 98 ac 00 00 00    	mov    0xac(%eax),%ebx
  popcli();
80103d6f:	e8 3c 05 00 00       	call   801042b0 <popcli>
void
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
80103d74:	85 db                	test   %ebx,%ebx
80103d76:	0f 84 87 00 00 00    	je     80103e03 <sleep+0xb3>
    panic("sleep");

  if(lk == 0)
80103d7c:	85 f6                	test   %esi,%esi
80103d7e:	74 76                	je     80103df6 <sleep+0xa6>
  // change p->state and then call sched.
  // Once we hold ptable.lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup runs with ptable.lock locked),
  // so it's okay to release lk.
  if(lk != &ptable.lock){  //DOC: sleeplock0
80103d80:	81 fe 80 2d 11 80    	cmp    $0x80112d80,%esi
80103d86:	74 50                	je     80103dd8 <sleep+0x88>
    acquire(&ptable.lock);  //DOC: sleeplock1
80103d88:	83 ec 0c             	sub    $0xc,%esp
80103d8b:	68 80 2d 11 80       	push   $0x80112d80
80103d90:	e8 bb 05 00 00       	call   80104350 <acquire>
    release(lk);
80103d95:	89 34 24             	mov    %esi,(%esp)
80103d98:	e8 63 06 00 00       	call   80104400 <release>
  }
  // Go to sleep.
  p->chan = chan;
80103d9d:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
80103da0:	c7 43 14 02 00 00 00 	movl   $0x2,0x14(%ebx)

  sched();
80103da7:	e8 64 fd ff ff       	call   80103b10 <sched>

  // Tidy up.
  p->chan = 0;
80103dac:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
80103db3:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103dba:	e8 41 06 00 00       	call   80104400 <release>
    acquire(lk);
80103dbf:	89 75 08             	mov    %esi,0x8(%ebp)
80103dc2:	83 c4 10             	add    $0x10,%esp
  }
}
80103dc5:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103dc8:	5b                   	pop    %ebx
80103dc9:	5e                   	pop    %esi
80103dca:	5f                   	pop    %edi
80103dcb:	5d                   	pop    %ebp
  p->chan = 0;

  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
80103dcc:	e9 7f 05 00 00       	jmp    80104350 <acquire>
80103dd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if(lk != &ptable.lock){  //DOC: sleeplock0
    acquire(&ptable.lock);  //DOC: sleeplock1
    release(lk);
  }
  // Go to sleep.
  p->chan = chan;
80103dd8:	89 7b 28             	mov    %edi,0x28(%ebx)
  p->state = SLEEPING;
80103ddb:	c7 43 14 02 00 00 00 	movl   $0x2,0x14(%ebx)

  sched();
80103de2:	e8 29 fd ff ff       	call   80103b10 <sched>

  // Tidy up.
  p->chan = 0;
80103de7:	c7 43 28 00 00 00 00 	movl   $0x0,0x28(%ebx)
  // Reacquire original lock.
  if(lk != &ptable.lock){  //DOC: sleeplock2
    release(&ptable.lock);
    acquire(lk);
  }
}
80103dee:	8d 65 f4             	lea    -0xc(%ebp),%esp
80103df1:	5b                   	pop    %ebx
80103df2:	5e                   	pop    %esi
80103df3:	5f                   	pop    %edi
80103df4:	5d                   	pop    %ebp
80103df5:	c3                   	ret    
  
  if(p == 0)
    panic("sleep");

  if(lk == 0)
    panic("sleep without lk");
80103df6:	83 ec 0c             	sub    $0xc,%esp
80103df9:	68 4f 76 10 80       	push   $0x8010764f
80103dfe:	e8 6d c5 ff ff       	call   80100370 <panic>
sleep(void *chan, struct spinlock *lk)
{
  struct proc *p = myproc();
  
  if(p == 0)
    panic("sleep");
80103e03:	83 ec 0c             	sub    $0xc,%esp
80103e06:	68 49 76 10 80       	push   $0x80107649
80103e0b:	e8 60 c5 ff ff       	call   80100370 <panic>

80103e10 <wait>:

// Wait for a child process to exit and return its pid.
// Return -1 if this process has no children.
int
wait(void)
{
80103e10:	55                   	push   %ebp
80103e11:	89 e5                	mov    %esp,%ebp
80103e13:	56                   	push   %esi
80103e14:	53                   	push   %ebx
// while reading proc from the cpu structure
struct proc*
myproc(void) {
  struct cpu *c;
  struct proc *p;
  pushcli();
80103e15:	e8 56 04 00 00       	call   80104270 <pushcli>
  c = mycpu();
80103e1a:	e8 e1 f8 ff ff       	call   80103700 <mycpu>
  p = c->proc;
80103e1f:	8b b0 ac 00 00 00    	mov    0xac(%eax),%esi
  popcli();
80103e25:	e8 86 04 00 00       	call   801042b0 <popcli>
{
  struct proc *p;
  int havekids, pid;
  struct proc *curproc = myproc();
  
  acquire(&ptable.lock);
80103e2a:	83 ec 0c             	sub    $0xc,%esp
80103e2d:	68 80 2d 11 80       	push   $0x80112d80
80103e32:	e8 19 05 00 00       	call   80104350 <acquire>
80103e37:	83 c4 10             	add    $0x10,%esp
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
80103e3a:	31 c0                	xor    %eax,%eax
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e3c:	bb b4 2d 11 80       	mov    $0x80112db4,%ebx
80103e41:	eb 13                	jmp    80103e56 <wait+0x46>
80103e43:	90                   	nop
80103e44:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80103e48:	81 c3 84 00 00 00    	add    $0x84,%ebx
80103e4e:	81 fb b4 4e 11 80    	cmp    $0x80114eb4,%ebx
80103e54:	74 22                	je     80103e78 <wait+0x68>
      if(p->parent != curproc)
80103e56:	39 73 1c             	cmp    %esi,0x1c(%ebx)
80103e59:	75 ed                	jne    80103e48 <wait+0x38>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
80103e5b:	83 7b 14 05          	cmpl   $0x5,0x14(%ebx)
80103e5f:	74 35                	je     80103e96 <wait+0x86>
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e61:	81 c3 84 00 00 00    	add    $0x84,%ebx
      if(p->parent != curproc)
        continue;
      havekids = 1;
80103e67:	b8 01 00 00 00       	mov    $0x1,%eax
  
  acquire(&ptable.lock);
  for(;;){
    // Scan through table looking for exited children.
    havekids = 0;
    for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103e6c:	81 fb b4 4e 11 80    	cmp    $0x80114eb4,%ebx
80103e72:	75 e2                	jne    80103e56 <wait+0x46>
80103e74:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        return pid;
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
80103e78:	85 c0                	test   %eax,%eax
80103e7a:	74 70                	je     80103eec <wait+0xdc>
80103e7c:	8b 46 2c             	mov    0x2c(%esi),%eax
80103e7f:	85 c0                	test   %eax,%eax
80103e81:	75 69                	jne    80103eec <wait+0xdc>
      release(&ptable.lock);
      return -1;
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
80103e83:	83 ec 08             	sub    $0x8,%esp
80103e86:	68 80 2d 11 80       	push   $0x80112d80
80103e8b:	56                   	push   %esi
80103e8c:	e8 bf fe ff ff       	call   80103d50 <sleep>
  }
80103e91:	83 c4 10             	add    $0x10,%esp
80103e94:	eb a4                	jmp    80103e3a <wait+0x2a>
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
80103e96:	83 ec 0c             	sub    $0xc,%esp
80103e99:	ff 73 10             	pushl  0x10(%ebx)
      if(p->parent != curproc)
        continue;
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
80103e9c:	8b 73 18             	mov    0x18(%ebx),%esi
        kfree(p->kstack);
80103e9f:	e8 3c e4 ff ff       	call   801022e0 <kfree>
        p->kstack = 0;
        freevm(p->pgdir);
80103ea4:	5a                   	pop    %edx
80103ea5:	ff 73 0c             	pushl  0xc(%ebx)
      havekids = 1;
      if(p->state == ZOMBIE){
        // Found one.
        pid = p->pid;
        kfree(p->kstack);
        p->kstack = 0;
80103ea8:	c7 43 10 00 00 00 00 	movl   $0x0,0x10(%ebx)
        freevm(p->pgdir);
80103eaf:	e8 7c 2e 00 00       	call   80106d30 <freevm>
        p->pid = 0;
80103eb4:	c7 43 18 00 00 00 00 	movl   $0x0,0x18(%ebx)
        p->parent = 0;
80103ebb:	c7 43 1c 00 00 00 00 	movl   $0x0,0x1c(%ebx)
        p->name[0] = 0;
80103ec2:	c6 43 74 00          	movb   $0x0,0x74(%ebx)
        p->killed = 0;
80103ec6:	c7 43 2c 00 00 00 00 	movl   $0x0,0x2c(%ebx)
        p->state = UNUSED;
80103ecd:	c7 43 14 00 00 00 00 	movl   $0x0,0x14(%ebx)
        release(&ptable.lock);
80103ed4:	c7 04 24 80 2d 11 80 	movl   $0x80112d80,(%esp)
80103edb:	e8 20 05 00 00       	call   80104400 <release>
        return pid;
80103ee0:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ee3:	8d 65 f8             	lea    -0x8(%ebp),%esp
        p->parent = 0;
        p->name[0] = 0;
        p->killed = 0;
        p->state = UNUSED;
        release(&ptable.lock);
        return pid;
80103ee6:	89 f0                	mov    %esi,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103ee8:	5b                   	pop    %ebx
80103ee9:	5e                   	pop    %esi
80103eea:	5d                   	pop    %ebp
80103eeb:	c3                   	ret    
      }
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
80103eec:	83 ec 0c             	sub    $0xc,%esp
80103eef:	68 80 2d 11 80       	push   $0x80112d80
80103ef4:	e8 07 05 00 00       	call   80104400 <release>
      return -1;
80103ef9:	83 c4 10             	add    $0x10,%esp
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103efc:	8d 65 f8             	lea    -0x8(%ebp),%esp
    }

    // No point waiting if we don't have any children.
    if(!havekids || curproc->killed){
      release(&ptable.lock);
      return -1;
80103eff:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }

    // Wait for children to exit.  (See wakeup1 call in proc_exit.)
    sleep(curproc, &ptable.lock);  //DOC: wait-sleep
  }
}
80103f04:	5b                   	pop    %ebx
80103f05:	5e                   	pop    %esi
80103f06:	5d                   	pop    %ebp
80103f07:	c3                   	ret    
80103f08:	90                   	nop
80103f09:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80103f10 <wakeup>:
}

// Wake up all processes sleeping on chan.
void
wakeup(void *chan)
{
80103f10:	55                   	push   %ebp
80103f11:	89 e5                	mov    %esp,%ebp
80103f13:	53                   	push   %ebx
80103f14:	83 ec 10             	sub    $0x10,%esp
80103f17:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&ptable.lock);
80103f1a:	68 80 2d 11 80       	push   $0x80112d80
80103f1f:	e8 2c 04 00 00       	call   80104350 <acquire>
80103f24:	83 c4 10             	add    $0x10,%esp
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f27:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80103f2c:	eb 0e                	jmp    80103f3c <wakeup+0x2c>
80103f2e:	66 90                	xchg   %ax,%ax
80103f30:	05 84 00 00 00       	add    $0x84,%eax
80103f35:	3d b4 4e 11 80       	cmp    $0x80114eb4,%eax
80103f3a:	74 1e                	je     80103f5a <wakeup+0x4a>
    if(p->state == SLEEPING && p->chan == chan)
80103f3c:	83 78 14 02          	cmpl   $0x2,0x14(%eax)
80103f40:	75 ee                	jne    80103f30 <wakeup+0x20>
80103f42:	3b 58 28             	cmp    0x28(%eax),%ebx
80103f45:	75 e9                	jne    80103f30 <wakeup+0x20>
      p->state = RUNNABLE;
80103f47:	c7 40 14 03 00 00 00 	movl   $0x3,0x14(%eax)
static void
wakeup1(void *chan)
{
  struct proc *p;

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++)
80103f4e:	05 84 00 00 00       	add    $0x84,%eax
80103f53:	3d b4 4e 11 80       	cmp    $0x80114eb4,%eax
80103f58:	75 e2                	jne    80103f3c <wakeup+0x2c>
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f5a:	c7 45 08 80 2d 11 80 	movl   $0x80112d80,0x8(%ebp)
}
80103f61:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103f64:	c9                   	leave  
void
wakeup(void *chan)
{
  acquire(&ptable.lock);
  wakeup1(chan);
  release(&ptable.lock);
80103f65:	e9 96 04 00 00       	jmp    80104400 <release>
80103f6a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80103f70 <kill>:
// Kill the process with the given pid.
// Process won't exit until it returns
// to user space (see trap in trap.c).
int
kill(int pid)
{
80103f70:	55                   	push   %ebp
80103f71:	89 e5                	mov    %esp,%ebp
80103f73:	53                   	push   %ebx
80103f74:	83 ec 10             	sub    $0x10,%esp
80103f77:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *p;

  acquire(&ptable.lock);
80103f7a:	68 80 2d 11 80       	push   $0x80112d80
80103f7f:	e8 cc 03 00 00       	call   80104350 <acquire>
80103f84:	83 c4 10             	add    $0x10,%esp
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
80103f87:	b8 b4 2d 11 80       	mov    $0x80112db4,%eax
80103f8c:	eb 0e                	jmp    80103f9c <kill+0x2c>
80103f8e:	66 90                	xchg   %ax,%ax
80103f90:	05 84 00 00 00       	add    $0x84,%eax
80103f95:	3d b4 4e 11 80       	cmp    $0x80114eb4,%eax
80103f9a:	74 3c                	je     80103fd8 <kill+0x68>
    if(p->pid == pid){
80103f9c:	39 58 18             	cmp    %ebx,0x18(%eax)
80103f9f:	75 ef                	jne    80103f90 <kill+0x20>
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fa1:	83 78 14 02          	cmpl   $0x2,0x14(%eax)
  struct proc *p;

  acquire(&ptable.lock);
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
80103fa5:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
80103fac:	74 1a                	je     80103fc8 <kill+0x58>
        p->state = RUNNABLE;
      release(&ptable.lock);
80103fae:	83 ec 0c             	sub    $0xc,%esp
80103fb1:	68 80 2d 11 80       	push   $0x80112d80
80103fb6:	e8 45 04 00 00       	call   80104400 <release>
      return 0;
80103fbb:	83 c4 10             	add    $0x10,%esp
80103fbe:	31 c0                	xor    %eax,%eax
    }
  }
  release(&ptable.lock);
  return -1;
}
80103fc0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103fc3:	c9                   	leave  
80103fc4:	c3                   	ret    
80103fc5:	8d 76 00             	lea    0x0(%esi),%esi
  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->pid == pid){
      p->killed = 1;
      // Wake process from sleep if necessary.
      if(p->state == SLEEPING)
        p->state = RUNNABLE;
80103fc8:	c7 40 14 03 00 00 00 	movl   $0x3,0x14(%eax)
80103fcf:	eb dd                	jmp    80103fae <kill+0x3e>
80103fd1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      release(&ptable.lock);
      return 0;
    }
  }
  release(&ptable.lock);
80103fd8:	83 ec 0c             	sub    $0xc,%esp
80103fdb:	68 80 2d 11 80       	push   $0x80112d80
80103fe0:	e8 1b 04 00 00       	call   80104400 <release>
  return -1;
80103fe5:	83 c4 10             	add    $0x10,%esp
80103fe8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80103fed:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80103ff0:	c9                   	leave  
80103ff1:	c3                   	ret    
80103ff2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80103ff9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104000 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
80104000:	55                   	push   %ebp
80104001:	89 e5                	mov    %esp,%ebp
80104003:	57                   	push   %edi
80104004:	56                   	push   %esi
80104005:	53                   	push   %ebx
80104006:	8d 75 e8             	lea    -0x18(%ebp),%esi
80104009:	bb 28 2e 11 80       	mov    $0x80112e28,%ebx
8010400e:	83 ec 3c             	sub    $0x3c,%esp
80104011:	eb 27                	jmp    8010403a <procdump+0x3a>
80104013:	90                   	nop
80104014:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
80104018:	83 ec 0c             	sub    $0xc,%esp
8010401b:	68 4b 7a 10 80       	push   $0x80107a4b
80104020:	e8 3b c6 ff ff       	call   80100660 <cprintf>
80104025:	83 c4 10             	add    $0x10,%esp
80104028:	81 c3 84 00 00 00    	add    $0x84,%ebx
  int i;
  struct proc *p;
  char *state;
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
8010402e:	81 fb 28 4f 11 80    	cmp    $0x80114f28,%ebx
80104034:	0f 84 7e 00 00 00    	je     801040b8 <procdump+0xb8>
    if(p->state == UNUSED)
8010403a:	8b 43 a0             	mov    -0x60(%ebx),%eax
8010403d:	85 c0                	test   %eax,%eax
8010403f:	74 e7                	je     80104028 <procdump+0x28>
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104041:	83 f8 05             	cmp    $0x5,%eax
      state = states[p->state];
    else
      state = "???";
80104044:	ba 60 76 10 80       	mov    $0x80107660,%edx
  uint pc[10];

  for(p = ptable.proc; p < &ptable.proc[NPROC]; p++){
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
80104049:	77 11                	ja     8010405c <procdump+0x5c>
8010404b:	8b 14 85 c0 76 10 80 	mov    -0x7fef8940(,%eax,4),%edx
      state = states[p->state];
    else
      state = "???";
80104052:	b8 60 76 10 80       	mov    $0x80107660,%eax
80104057:	85 d2                	test   %edx,%edx
80104059:	0f 44 d0             	cmove  %eax,%edx
    cprintf("%d %s %s", p->pid, state, p->name);
8010405c:	53                   	push   %ebx
8010405d:	52                   	push   %edx
8010405e:	ff 73 a4             	pushl  -0x5c(%ebx)
80104061:	68 64 76 10 80       	push   $0x80107664
80104066:	e8 f5 c5 ff ff       	call   80100660 <cprintf>
    if(p->state == SLEEPING){
8010406b:	83 c4 10             	add    $0x10,%esp
8010406e:	83 7b a0 02          	cmpl   $0x2,-0x60(%ebx)
80104072:	75 a4                	jne    80104018 <procdump+0x18>
      getcallerpcs((uint*)p->context->ebp+2, pc);
80104074:	8d 45 c0             	lea    -0x40(%ebp),%eax
80104077:	83 ec 08             	sub    $0x8,%esp
8010407a:	8d 7d c0             	lea    -0x40(%ebp),%edi
8010407d:	50                   	push   %eax
8010407e:	8b 43 b0             	mov    -0x50(%ebx),%eax
80104081:	8b 40 0c             	mov    0xc(%eax),%eax
80104084:	83 c0 08             	add    $0x8,%eax
80104087:	50                   	push   %eax
80104088:	e8 83 01 00 00       	call   80104210 <getcallerpcs>
8010408d:	83 c4 10             	add    $0x10,%esp
      for(i=0; i<10 && pc[i] != 0; i++)
80104090:	8b 17                	mov    (%edi),%edx
80104092:	85 d2                	test   %edx,%edx
80104094:	74 82                	je     80104018 <procdump+0x18>
        cprintf(" %p", pc[i]);
80104096:	83 ec 08             	sub    $0x8,%esp
80104099:	83 c7 04             	add    $0x4,%edi
8010409c:	52                   	push   %edx
8010409d:	68 a1 70 10 80       	push   $0x801070a1
801040a2:	e8 b9 c5 ff ff       	call   80100660 <cprintf>
    else
      state = "???";
    cprintf("%d %s %s", p->pid, state, p->name);
    if(p->state == SLEEPING){
      getcallerpcs((uint*)p->context->ebp+2, pc);
      for(i=0; i<10 && pc[i] != 0; i++)
801040a7:	83 c4 10             	add    $0x10,%esp
801040aa:	39 f7                	cmp    %esi,%edi
801040ac:	75 e2                	jne    80104090 <procdump+0x90>
801040ae:	e9 65 ff ff ff       	jmp    80104018 <procdump+0x18>
801040b3:	90                   	nop
801040b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
        cprintf(" %p", pc[i]);
    }
    cprintf("\n");
  }
801040b8:	8d 65 f4             	lea    -0xc(%ebp),%esp
801040bb:	5b                   	pop    %ebx
801040bc:	5e                   	pop    %esi
801040bd:	5f                   	pop    %edi
801040be:	5d                   	pop    %ebp
801040bf:	c3                   	ret    

801040c0 <initsleeplock>:
#include "spinlock.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
801040c0:	55                   	push   %ebp
801040c1:	89 e5                	mov    %esp,%ebp
801040c3:	53                   	push   %ebx
801040c4:	83 ec 0c             	sub    $0xc,%esp
801040c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  initlock(&lk->lk, "sleep lock");
801040ca:	68 d8 76 10 80       	push   $0x801076d8
801040cf:	8d 43 04             	lea    0x4(%ebx),%eax
801040d2:	50                   	push   %eax
801040d3:	e8 18 01 00 00       	call   801041f0 <initlock>
  lk->name = name;
801040d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  lk->locked = 0;
801040db:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
}
801040e1:	83 c4 10             	add    $0x10,%esp
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
  lk->locked = 0;
  lk->pid = 0;
801040e4:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)

void
initsleeplock(struct sleeplock *lk, char *name)
{
  initlock(&lk->lk, "sleep lock");
  lk->name = name;
801040eb:	89 43 38             	mov    %eax,0x38(%ebx)
  lk->locked = 0;
  lk->pid = 0;
}
801040ee:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801040f1:	c9                   	leave  
801040f2:	c3                   	ret    
801040f3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801040f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104100 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
80104100:	55                   	push   %ebp
80104101:	89 e5                	mov    %esp,%ebp
80104103:	56                   	push   %esi
80104104:	53                   	push   %ebx
80104105:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104108:	83 ec 0c             	sub    $0xc,%esp
8010410b:	8d 73 04             	lea    0x4(%ebx),%esi
8010410e:	56                   	push   %esi
8010410f:	e8 3c 02 00 00       	call   80104350 <acquire>
  while (lk->locked) {
80104114:	8b 13                	mov    (%ebx),%edx
80104116:	83 c4 10             	add    $0x10,%esp
80104119:	85 d2                	test   %edx,%edx
8010411b:	74 16                	je     80104133 <acquiresleep+0x33>
8010411d:	8d 76 00             	lea    0x0(%esi),%esi
    sleep(lk, &lk->lk);
80104120:	83 ec 08             	sub    $0x8,%esp
80104123:	56                   	push   %esi
80104124:	53                   	push   %ebx
80104125:	e8 26 fc ff ff       	call   80103d50 <sleep>

void
acquiresleep(struct sleeplock *lk)
{
  acquire(&lk->lk);
  while (lk->locked) {
8010412a:	8b 03                	mov    (%ebx),%eax
8010412c:	83 c4 10             	add    $0x10,%esp
8010412f:	85 c0                	test   %eax,%eax
80104131:	75 ed                	jne    80104120 <acquiresleep+0x20>
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
80104133:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  lk->pid = myproc()->pid;
80104139:	e8 62 f6 ff ff       	call   801037a0 <myproc>
8010413e:	8b 40 18             	mov    0x18(%eax),%eax
80104141:	89 43 3c             	mov    %eax,0x3c(%ebx)
  release(&lk->lk);
80104144:	89 75 08             	mov    %esi,0x8(%ebp)
}
80104147:	8d 65 f8             	lea    -0x8(%ebp),%esp
8010414a:	5b                   	pop    %ebx
8010414b:	5e                   	pop    %esi
8010414c:	5d                   	pop    %ebp
  while (lk->locked) {
    sleep(lk, &lk->lk);
  }
  lk->locked = 1;
  lk->pid = myproc()->pid;
  release(&lk->lk);
8010414d:	e9 ae 02 00 00       	jmp    80104400 <release>
80104152:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104159:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104160 <releasesleep>:
}

void
releasesleep(struct sleeplock *lk)
{
80104160:	55                   	push   %ebp
80104161:	89 e5                	mov    %esp,%ebp
80104163:	56                   	push   %esi
80104164:	53                   	push   %ebx
80104165:	8b 5d 08             	mov    0x8(%ebp),%ebx
  acquire(&lk->lk);
80104168:	83 ec 0c             	sub    $0xc,%esp
8010416b:	8d 73 04             	lea    0x4(%ebx),%esi
8010416e:	56                   	push   %esi
8010416f:	e8 dc 01 00 00       	call   80104350 <acquire>
  lk->locked = 0;
80104174:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
  lk->pid = 0;
8010417a:	c7 43 3c 00 00 00 00 	movl   $0x0,0x3c(%ebx)
  wakeup(lk);
80104181:	89 1c 24             	mov    %ebx,(%esp)
80104184:	e8 87 fd ff ff       	call   80103f10 <wakeup>
  release(&lk->lk);
80104189:	89 75 08             	mov    %esi,0x8(%ebp)
8010418c:	83 c4 10             	add    $0x10,%esp
}
8010418f:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104192:	5b                   	pop    %ebx
80104193:	5e                   	pop    %esi
80104194:	5d                   	pop    %ebp
{
  acquire(&lk->lk);
  lk->locked = 0;
  lk->pid = 0;
  wakeup(lk);
  release(&lk->lk);
80104195:	e9 66 02 00 00       	jmp    80104400 <release>
8010419a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

801041a0 <holdingsleep>:
}

int
holdingsleep(struct sleeplock *lk)
{
801041a0:	55                   	push   %ebp
801041a1:	89 e5                	mov    %esp,%ebp
801041a3:	57                   	push   %edi
801041a4:	56                   	push   %esi
801041a5:	53                   	push   %ebx
801041a6:	31 ff                	xor    %edi,%edi
801041a8:	83 ec 18             	sub    $0x18,%esp
801041ab:	8b 5d 08             	mov    0x8(%ebp),%ebx
  int r;
  
  acquire(&lk->lk);
801041ae:	8d 73 04             	lea    0x4(%ebx),%esi
801041b1:	56                   	push   %esi
801041b2:	e8 99 01 00 00       	call   80104350 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
801041b7:	8b 03                	mov    (%ebx),%eax
801041b9:	83 c4 10             	add    $0x10,%esp
801041bc:	85 c0                	test   %eax,%eax
801041be:	74 13                	je     801041d3 <holdingsleep+0x33>
801041c0:	8b 5b 3c             	mov    0x3c(%ebx),%ebx
801041c3:	e8 d8 f5 ff ff       	call   801037a0 <myproc>
801041c8:	39 58 18             	cmp    %ebx,0x18(%eax)
801041cb:	0f 94 c0             	sete   %al
801041ce:	0f b6 c0             	movzbl %al,%eax
801041d1:	89 c7                	mov    %eax,%edi
  release(&lk->lk);
801041d3:	83 ec 0c             	sub    $0xc,%esp
801041d6:	56                   	push   %esi
801041d7:	e8 24 02 00 00       	call   80104400 <release>
  return r;
}
801041dc:	8d 65 f4             	lea    -0xc(%ebp),%esp
801041df:	89 f8                	mov    %edi,%eax
801041e1:	5b                   	pop    %ebx
801041e2:	5e                   	pop    %esi
801041e3:	5f                   	pop    %edi
801041e4:	5d                   	pop    %ebp
801041e5:	c3                   	ret    
801041e6:	66 90                	xchg   %ax,%ax
801041e8:	66 90                	xchg   %ax,%ax
801041ea:	66 90                	xchg   %ax,%ax
801041ec:	66 90                	xchg   %ax,%ax
801041ee:	66 90                	xchg   %ax,%ax

801041f0 <initlock>:
#include "proc.h"
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
801041f0:	55                   	push   %ebp
801041f1:	89 e5                	mov    %esp,%ebp
801041f3:	8b 45 08             	mov    0x8(%ebp),%eax
  lk->name = name;
801041f6:	8b 55 0c             	mov    0xc(%ebp),%edx
  lk->locked = 0;
801041f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
#include "spinlock.h"

void
initlock(struct spinlock *lk, char *name)
{
  lk->name = name;
801041ff:	89 50 04             	mov    %edx,0x4(%eax)
  lk->locked = 0;
  lk->cpu = 0;
80104202:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
}
80104209:	5d                   	pop    %ebp
8010420a:	c3                   	ret    
8010420b:	90                   	nop
8010420c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104210 <getcallerpcs>:
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104210:	55                   	push   %ebp
80104211:	89 e5                	mov    %esp,%ebp
80104213:	53                   	push   %ebx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104214:	8b 45 08             	mov    0x8(%ebp),%eax
}

// Record the current call stack in pcs[] by following the %ebp chain.
void
getcallerpcs(void *v, uint pcs[])
{
80104217:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
8010421a:	8d 50 f8             	lea    -0x8(%eax),%edx
  for(i = 0; i < 10; i++){
8010421d:	31 c0                	xor    %eax,%eax
8010421f:	90                   	nop
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
80104220:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
80104226:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
8010422c:	77 1a                	ja     80104248 <getcallerpcs+0x38>
      break;
    pcs[i] = ebp[1];     // saved %eip
8010422e:	8b 5a 04             	mov    0x4(%edx),%ebx
80104231:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104234:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
80104237:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
80104239:	83 f8 0a             	cmp    $0xa,%eax
8010423c:	75 e2                	jne    80104220 <getcallerpcs+0x10>
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
}
8010423e:	5b                   	pop    %ebx
8010423f:	5d                   	pop    %ebp
80104240:	c3                   	ret    
80104241:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
80104248:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010424f:	83 c0 01             	add    $0x1,%eax
80104252:	83 f8 0a             	cmp    $0xa,%eax
80104255:	74 e7                	je     8010423e <getcallerpcs+0x2e>
    pcs[i] = 0;
80104257:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
8010425e:	83 c0 01             	add    $0x1,%eax
80104261:	83 f8 0a             	cmp    $0xa,%eax
80104264:	75 e2                	jne    80104248 <getcallerpcs+0x38>
80104266:	eb d6                	jmp    8010423e <getcallerpcs+0x2e>
80104268:	90                   	nop
80104269:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80104270 <pushcli>:
// it takes two popcli to undo two pushcli.  Also, if interrupts
// are off, then pushcli, popcli leaves them off.

void
pushcli(void)
{
80104270:	55                   	push   %ebp
80104271:	89 e5                	mov    %esp,%ebp
80104273:	53                   	push   %ebx
80104274:	83 ec 04             	sub    $0x4,%esp
80104277:	9c                   	pushf  
80104278:	5b                   	pop    %ebx
}

static inline void
cli(void)
{
  asm volatile("cli");
80104279:	fa                   	cli    
  int eflags;

  eflags = readeflags();
  cli();
  if(mycpu()->ncli == 0)
8010427a:	e8 81 f4 ff ff       	call   80103700 <mycpu>
8010427f:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
80104285:	85 c0                	test   %eax,%eax
80104287:	75 11                	jne    8010429a <pushcli+0x2a>
    mycpu()->intena = eflags & FL_IF;
80104289:	81 e3 00 02 00 00    	and    $0x200,%ebx
8010428f:	e8 6c f4 ff ff       	call   80103700 <mycpu>
80104294:	89 98 a8 00 00 00    	mov    %ebx,0xa8(%eax)
  mycpu()->ncli += 1;
8010429a:	e8 61 f4 ff ff       	call   80103700 <mycpu>
8010429f:	83 80 a4 00 00 00 01 	addl   $0x1,0xa4(%eax)
}
801042a6:	83 c4 04             	add    $0x4,%esp
801042a9:	5b                   	pop    %ebx
801042aa:	5d                   	pop    %ebp
801042ab:	c3                   	ret    
801042ac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801042b0 <popcli>:

void
popcli(void)
{
801042b0:	55                   	push   %ebp
801042b1:	89 e5                	mov    %esp,%ebp
801042b3:	83 ec 08             	sub    $0x8,%esp

static inline uint
readeflags(void)
{
  uint eflags;
  asm volatile("pushfl; popl %0" : "=r" (eflags));
801042b6:	9c                   	pushf  
801042b7:	58                   	pop    %eax
  if(readeflags()&FL_IF)
801042b8:	f6 c4 02             	test   $0x2,%ah
801042bb:	75 52                	jne    8010430f <popcli+0x5f>
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
801042bd:	e8 3e f4 ff ff       	call   80103700 <mycpu>
801042c2:	8b 88 a4 00 00 00    	mov    0xa4(%eax),%ecx
801042c8:	8d 51 ff             	lea    -0x1(%ecx),%edx
801042cb:	85 d2                	test   %edx,%edx
801042cd:	89 90 a4 00 00 00    	mov    %edx,0xa4(%eax)
801042d3:	78 2d                	js     80104302 <popcli+0x52>
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042d5:	e8 26 f4 ff ff       	call   80103700 <mycpu>
801042da:	8b 90 a4 00 00 00    	mov    0xa4(%eax),%edx
801042e0:	85 d2                	test   %edx,%edx
801042e2:	74 0c                	je     801042f0 <popcli+0x40>
    sti();
}
801042e4:	c9                   	leave  
801042e5:	c3                   	ret    
801042e6:	8d 76 00             	lea    0x0(%esi),%esi
801042e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
  if(mycpu()->ncli == 0 && mycpu()->intena)
801042f0:	e8 0b f4 ff ff       	call   80103700 <mycpu>
801042f5:	8b 80 a8 00 00 00    	mov    0xa8(%eax),%eax
801042fb:	85 c0                	test   %eax,%eax
801042fd:	74 e5                	je     801042e4 <popcli+0x34>
}

static inline void
sti(void)
{
  asm volatile("sti");
801042ff:	fb                   	sti    
    sti();
}
80104300:	c9                   	leave  
80104301:	c3                   	ret    
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
  if(--mycpu()->ncli < 0)
    panic("popcli");
80104302:	83 ec 0c             	sub    $0xc,%esp
80104305:	68 fa 76 10 80       	push   $0x801076fa
8010430a:	e8 61 c0 ff ff       	call   80100370 <panic>

void
popcli(void)
{
  if(readeflags()&FL_IF)
    panic("popcli - interruptible");
8010430f:	83 ec 0c             	sub    $0xc,%esp
80104312:	68 e3 76 10 80       	push   $0x801076e3
80104317:	e8 54 c0 ff ff       	call   80100370 <panic>
8010431c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104320 <holding>:
}

// Check whether this cpu is holding the lock.
int
holding(struct spinlock *lock)
{
80104320:	55                   	push   %ebp
80104321:	89 e5                	mov    %esp,%ebp
80104323:	56                   	push   %esi
80104324:	53                   	push   %ebx
80104325:	8b 75 08             	mov    0x8(%ebp),%esi
80104328:	31 db                	xor    %ebx,%ebx
  int r;
  pushcli();
8010432a:	e8 41 ff ff ff       	call   80104270 <pushcli>
  r = lock->locked && lock->cpu == mycpu();
8010432f:	8b 06                	mov    (%esi),%eax
80104331:	85 c0                	test   %eax,%eax
80104333:	74 10                	je     80104345 <holding+0x25>
80104335:	8b 5e 08             	mov    0x8(%esi),%ebx
80104338:	e8 c3 f3 ff ff       	call   80103700 <mycpu>
8010433d:	39 c3                	cmp    %eax,%ebx
8010433f:	0f 94 c3             	sete   %bl
80104342:	0f b6 db             	movzbl %bl,%ebx
  popcli();
80104345:	e8 66 ff ff ff       	call   801042b0 <popcli>
  return r;
}
8010434a:	89 d8                	mov    %ebx,%eax
8010434c:	5b                   	pop    %ebx
8010434d:	5e                   	pop    %esi
8010434e:	5d                   	pop    %ebp
8010434f:	c3                   	ret    

80104350 <acquire>:
// Loops (spins) until the lock is acquired.
// Holding a lock for a long time may cause
// other CPUs to waste time spinning to acquire it.
void
acquire(struct spinlock *lk)
{
80104350:	55                   	push   %ebp
80104351:	89 e5                	mov    %esp,%ebp
80104353:	53                   	push   %ebx
80104354:	83 ec 04             	sub    $0x4,%esp
  pushcli(); // disable interrupts to avoid deadlock.
80104357:	e8 14 ff ff ff       	call   80104270 <pushcli>
  if(holding(lk))
8010435c:	8b 5d 08             	mov    0x8(%ebp),%ebx
8010435f:	83 ec 0c             	sub    $0xc,%esp
80104362:	53                   	push   %ebx
80104363:	e8 b8 ff ff ff       	call   80104320 <holding>
80104368:	83 c4 10             	add    $0x10,%esp
8010436b:	85 c0                	test   %eax,%eax
8010436d:	0f 85 7d 00 00 00    	jne    801043f0 <acquire+0xa0>
xchg(volatile uint *addr, uint newval)
{
  uint result;

  // The + in "+m" denotes a read-modify-write operand.
  asm volatile("lock; xchgl %0, %1" :
80104373:	ba 01 00 00 00       	mov    $0x1,%edx
80104378:	eb 09                	jmp    80104383 <acquire+0x33>
8010437a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104380:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104383:	89 d0                	mov    %edx,%eax
80104385:	f0 87 03             	lock xchg %eax,(%ebx)
    panic("acquire");

  // The xchg is atomic.
  while(xchg(&lk->locked, 1) != 0)
80104388:	85 c0                	test   %eax,%eax
8010438a:	75 f4                	jne    80104380 <acquire+0x30>
    ;

  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();
8010438c:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
80104391:	8b 5d 08             	mov    0x8(%ebp),%ebx
80104394:	e8 67 f3 ff ff       	call   80103700 <mycpu>
getcallerpcs(void *v, uint pcs[])
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
80104399:	89 ea                	mov    %ebp,%edx
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
8010439b:	8d 4b 0c             	lea    0xc(%ebx),%ecx
  // past this point, to ensure that the critical section's memory
  // references happen after the lock is acquired.
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
8010439e:	89 43 08             	mov    %eax,0x8(%ebx)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043a1:	31 c0                	xor    %eax,%eax
801043a3:	90                   	nop
801043a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
801043a8:	8d 9a 00 00 00 80    	lea    -0x80000000(%edx),%ebx
801043ae:	81 fb fe ff ff 7f    	cmp    $0x7ffffffe,%ebx
801043b4:	77 1a                	ja     801043d0 <acquire+0x80>
      break;
    pcs[i] = ebp[1];     // saved %eip
801043b6:	8b 5a 04             	mov    0x4(%edx),%ebx
801043b9:	89 1c 81             	mov    %ebx,(%ecx,%eax,4)
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043bc:	83 c0 01             	add    $0x1,%eax
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
801043bf:	8b 12                	mov    (%edx),%edx
{
  uint *ebp;
  int i;

  ebp = (uint*)v - 2;
  for(i = 0; i < 10; i++){
801043c1:	83 f8 0a             	cmp    $0xa,%eax
801043c4:	75 e2                	jne    801043a8 <acquire+0x58>
  __sync_synchronize();

  // Record info about lock acquisition for debugging.
  lk->cpu = mycpu();
  getcallerpcs(&lk, lk->pcs);
}
801043c6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801043c9:	c9                   	leave  
801043ca:	c3                   	ret    
801043cb:	90                   	nop
801043cc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
    pcs[i] = 0;
801043d0:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043d7:	83 c0 01             	add    $0x1,%eax
801043da:	83 f8 0a             	cmp    $0xa,%eax
801043dd:	74 e7                	je     801043c6 <acquire+0x76>
    pcs[i] = 0;
801043df:	c7 04 81 00 00 00 00 	movl   $0x0,(%ecx,%eax,4)
    if(ebp == 0 || ebp < (uint*)KERNBASE || ebp == (uint*)0xffffffff)
      break;
    pcs[i] = ebp[1];     // saved %eip
    ebp = (uint*)ebp[0]; // saved %ebp
  }
  for(; i < 10; i++)
801043e6:	83 c0 01             	add    $0x1,%eax
801043e9:	83 f8 0a             	cmp    $0xa,%eax
801043ec:	75 e2                	jne    801043d0 <acquire+0x80>
801043ee:	eb d6                	jmp    801043c6 <acquire+0x76>
void
acquire(struct spinlock *lk)
{
  pushcli(); // disable interrupts to avoid deadlock.
  if(holding(lk))
    panic("acquire");
801043f0:	83 ec 0c             	sub    $0xc,%esp
801043f3:	68 01 77 10 80       	push   $0x80107701
801043f8:	e8 73 bf ff ff       	call   80100370 <panic>
801043fd:	8d 76 00             	lea    0x0(%esi),%esi

80104400 <release>:
}

// Release the lock.
void
release(struct spinlock *lk)
{
80104400:	55                   	push   %ebp
80104401:	89 e5                	mov    %esp,%ebp
80104403:	53                   	push   %ebx
80104404:	83 ec 10             	sub    $0x10,%esp
80104407:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(!holding(lk))
8010440a:	53                   	push   %ebx
8010440b:	e8 10 ff ff ff       	call   80104320 <holding>
80104410:	83 c4 10             	add    $0x10,%esp
80104413:	85 c0                	test   %eax,%eax
80104415:	74 22                	je     80104439 <release+0x39>
    panic("release");

  lk->pcs[0] = 0;
80104417:	c7 43 0c 00 00 00 00 	movl   $0x0,0xc(%ebx)
  lk->cpu = 0;
8010441e:	c7 43 08 00 00 00 00 	movl   $0x0,0x8(%ebx)
  // Tell the C compiler and the processor to not move loads or stores
  // past this point, to ensure that all the stores in the critical
  // section are visible to other cores before the lock is released.
  // Both the C compiler and the hardware may re-order loads and
  // stores; __sync_synchronize() tells them both not to.
  __sync_synchronize();
80104425:	f0 83 0c 24 00       	lock orl $0x0,(%esp)

  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );
8010442a:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)

  popcli();
}
80104430:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80104433:	c9                   	leave  
  // Release the lock, equivalent to lk->locked = 0.
  // This code can't use a C assignment, since it might
  // not be atomic. A real OS would use C atomics here.
  asm volatile("movl $0, %0" : "+m" (lk->locked) : );

  popcli();
80104434:	e9 77 fe ff ff       	jmp    801042b0 <popcli>
// Release the lock.
void
release(struct spinlock *lk)
{
  if(!holding(lk))
    panic("release");
80104439:	83 ec 0c             	sub    $0xc,%esp
8010443c:	68 09 77 10 80       	push   $0x80107709
80104441:	e8 2a bf ff ff       	call   80100370 <panic>
80104446:	66 90                	xchg   %ax,%ax
80104448:	66 90                	xchg   %ax,%ax
8010444a:	66 90                	xchg   %ax,%ax
8010444c:	66 90                	xchg   %ax,%ax
8010444e:	66 90                	xchg   %ax,%ax

80104450 <memset>:
#include "types.h"
#include "x86.h"

void*
memset(void *dst, int c, uint n)
{
80104450:	55                   	push   %ebp
80104451:	89 e5                	mov    %esp,%ebp
80104453:	57                   	push   %edi
80104454:	53                   	push   %ebx
80104455:	8b 55 08             	mov    0x8(%ebp),%edx
80104458:	8b 4d 10             	mov    0x10(%ebp),%ecx
  if ((int)dst%4 == 0 && n%4 == 0){
8010445b:	f6 c2 03             	test   $0x3,%dl
8010445e:	75 05                	jne    80104465 <memset+0x15>
80104460:	f6 c1 03             	test   $0x3,%cl
80104463:	74 13                	je     80104478 <memset+0x28>
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
80104465:	89 d7                	mov    %edx,%edi
80104467:	8b 45 0c             	mov    0xc(%ebp),%eax
8010446a:	fc                   	cld    
8010446b:	f3 aa                	rep stos %al,%es:(%edi)
    c &= 0xFF;
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
8010446d:	5b                   	pop    %ebx
8010446e:	89 d0                	mov    %edx,%eax
80104470:	5f                   	pop    %edi
80104471:	5d                   	pop    %ebp
80104472:	c3                   	ret    
80104473:	90                   	nop
80104474:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

void*
memset(void *dst, int c, uint n)
{
  if ((int)dst%4 == 0 && n%4 == 0){
    c &= 0xFF;
80104478:	0f b6 7d 0c          	movzbl 0xc(%ebp),%edi
}

static inline void
stosl(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosl" :
8010447c:	c1 e9 02             	shr    $0x2,%ecx
8010447f:	89 fb                	mov    %edi,%ebx
80104481:	89 f8                	mov    %edi,%eax
80104483:	c1 e3 18             	shl    $0x18,%ebx
80104486:	c1 e0 10             	shl    $0x10,%eax
80104489:	09 d8                	or     %ebx,%eax
8010448b:	09 f8                	or     %edi,%eax
8010448d:	c1 e7 08             	shl    $0x8,%edi
80104490:	09 f8                	or     %edi,%eax
80104492:	89 d7                	mov    %edx,%edi
80104494:	fc                   	cld    
80104495:	f3 ab                	rep stos %eax,%es:(%edi)
    stosl(dst, (c<<24)|(c<<16)|(c<<8)|c, n/4);
  } else
    stosb(dst, c, n);
  return dst;
}
80104497:	5b                   	pop    %ebx
80104498:	89 d0                	mov    %edx,%eax
8010449a:	5f                   	pop    %edi
8010449b:	5d                   	pop    %ebp
8010449c:	c3                   	ret    
8010449d:	8d 76 00             	lea    0x0(%esi),%esi

801044a0 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
801044a0:	55                   	push   %ebp
801044a1:	89 e5                	mov    %esp,%ebp
801044a3:	57                   	push   %edi
801044a4:	56                   	push   %esi
801044a5:	8b 45 10             	mov    0x10(%ebp),%eax
801044a8:	53                   	push   %ebx
801044a9:	8b 75 0c             	mov    0xc(%ebp),%esi
801044ac:	8b 5d 08             	mov    0x8(%ebp),%ebx
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044af:	85 c0                	test   %eax,%eax
801044b1:	74 29                	je     801044dc <memcmp+0x3c>
    if(*s1 != *s2)
801044b3:	0f b6 13             	movzbl (%ebx),%edx
801044b6:	0f b6 0e             	movzbl (%esi),%ecx
801044b9:	38 d1                	cmp    %dl,%cl
801044bb:	75 2b                	jne    801044e8 <memcmp+0x48>
801044bd:	8d 78 ff             	lea    -0x1(%eax),%edi
801044c0:	31 c0                	xor    %eax,%eax
801044c2:	eb 14                	jmp    801044d8 <memcmp+0x38>
801044c4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
801044c8:	0f b6 54 03 01       	movzbl 0x1(%ebx,%eax,1),%edx
801044cd:	83 c0 01             	add    $0x1,%eax
801044d0:	0f b6 0c 06          	movzbl (%esi,%eax,1),%ecx
801044d4:	38 ca                	cmp    %cl,%dl
801044d6:	75 10                	jne    801044e8 <memcmp+0x48>
{
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
801044d8:	39 f8                	cmp    %edi,%eax
801044da:	75 ec                	jne    801044c8 <memcmp+0x28>
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
}
801044dc:	5b                   	pop    %ebx
    if(*s1 != *s2)
      return *s1 - *s2;
    s1++, s2++;
  }

  return 0;
801044dd:	31 c0                	xor    %eax,%eax
}
801044df:	5e                   	pop    %esi
801044e0:	5f                   	pop    %edi
801044e1:	5d                   	pop    %ebp
801044e2:	c3                   	ret    
801044e3:	90                   	nop
801044e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801044e8:	0f b6 c2             	movzbl %dl,%eax
    s1++, s2++;
  }

  return 0;
}
801044eb:	5b                   	pop    %ebx

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    if(*s1 != *s2)
      return *s1 - *s2;
801044ec:	29 c8                	sub    %ecx,%eax
    s1++, s2++;
  }

  return 0;
}
801044ee:	5e                   	pop    %esi
801044ef:	5f                   	pop    %edi
801044f0:	5d                   	pop    %ebp
801044f1:	c3                   	ret    
801044f2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801044f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104500 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
80104500:	55                   	push   %ebp
80104501:	89 e5                	mov    %esp,%ebp
80104503:	56                   	push   %esi
80104504:	53                   	push   %ebx
80104505:	8b 45 08             	mov    0x8(%ebp),%eax
80104508:	8b 75 0c             	mov    0xc(%ebp),%esi
8010450b:	8b 5d 10             	mov    0x10(%ebp),%ebx
  const char *s;
  char *d;

  s = src;
  d = dst;
  if(s < d && s + n > d){
8010450e:	39 c6                	cmp    %eax,%esi
80104510:	73 2e                	jae    80104540 <memmove+0x40>
80104512:	8d 0c 1e             	lea    (%esi,%ebx,1),%ecx
80104515:	39 c8                	cmp    %ecx,%eax
80104517:	73 27                	jae    80104540 <memmove+0x40>
    s += n;
    d += n;
    while(n-- > 0)
80104519:	85 db                	test   %ebx,%ebx
8010451b:	8d 53 ff             	lea    -0x1(%ebx),%edx
8010451e:	74 17                	je     80104537 <memmove+0x37>
      *--d = *--s;
80104520:	29 d9                	sub    %ebx,%ecx
80104522:	89 cb                	mov    %ecx,%ebx
80104524:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104528:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
8010452c:	88 0c 10             	mov    %cl,(%eax,%edx,1)
  s = src;
  d = dst;
  if(s < d && s + n > d){
    s += n;
    d += n;
    while(n-- > 0)
8010452f:	83 ea 01             	sub    $0x1,%edx
80104532:	83 fa ff             	cmp    $0xffffffff,%edx
80104535:	75 f1                	jne    80104528 <memmove+0x28>
  } else
    while(n-- > 0)
      *d++ = *s++;

  return dst;
}
80104537:	5b                   	pop    %ebx
80104538:	5e                   	pop    %esi
80104539:	5d                   	pop    %ebp
8010453a:	c3                   	ret    
8010453b:	90                   	nop
8010453c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
80104540:	31 d2                	xor    %edx,%edx
80104542:	85 db                	test   %ebx,%ebx
80104544:	74 f1                	je     80104537 <memmove+0x37>
80104546:	8d 76 00             	lea    0x0(%esi),%esi
80104549:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      *d++ = *s++;
80104550:	0f b6 0c 16          	movzbl (%esi,%edx,1),%ecx
80104554:	88 0c 10             	mov    %cl,(%eax,%edx,1)
80104557:	83 c2 01             	add    $0x1,%edx
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
8010455a:	39 d3                	cmp    %edx,%ebx
8010455c:	75 f2                	jne    80104550 <memmove+0x50>
      *d++ = *s++;

  return dst;
}
8010455e:	5b                   	pop    %ebx
8010455f:	5e                   	pop    %esi
80104560:	5d                   	pop    %ebp
80104561:	c3                   	ret    
80104562:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104569:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104570 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
80104570:	55                   	push   %ebp
80104571:	89 e5                	mov    %esp,%ebp
  return memmove(dst, src, n);
}
80104573:	5d                   	pop    %ebp

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
  return memmove(dst, src, n);
80104574:	eb 8a                	jmp    80104500 <memmove>
80104576:	8d 76 00             	lea    0x0(%esi),%esi
80104579:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104580 <strncmp>:
}

int
strncmp(const char *p, const char *q, uint n)
{
80104580:	55                   	push   %ebp
80104581:	89 e5                	mov    %esp,%ebp
80104583:	57                   	push   %edi
80104584:	56                   	push   %esi
80104585:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104588:	53                   	push   %ebx
80104589:	8b 7d 08             	mov    0x8(%ebp),%edi
8010458c:	8b 75 0c             	mov    0xc(%ebp),%esi
  while(n > 0 && *p && *p == *q)
8010458f:	85 c9                	test   %ecx,%ecx
80104591:	74 37                	je     801045ca <strncmp+0x4a>
80104593:	0f b6 17             	movzbl (%edi),%edx
80104596:	0f b6 1e             	movzbl (%esi),%ebx
80104599:	84 d2                	test   %dl,%dl
8010459b:	74 3f                	je     801045dc <strncmp+0x5c>
8010459d:	38 d3                	cmp    %dl,%bl
8010459f:	75 3b                	jne    801045dc <strncmp+0x5c>
801045a1:	8d 47 01             	lea    0x1(%edi),%eax
801045a4:	01 cf                	add    %ecx,%edi
801045a6:	eb 1b                	jmp    801045c3 <strncmp+0x43>
801045a8:	90                   	nop
801045a9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045b0:	0f b6 10             	movzbl (%eax),%edx
801045b3:	84 d2                	test   %dl,%dl
801045b5:	74 21                	je     801045d8 <strncmp+0x58>
801045b7:	0f b6 19             	movzbl (%ecx),%ebx
801045ba:	83 c0 01             	add    $0x1,%eax
801045bd:	89 ce                	mov    %ecx,%esi
801045bf:	38 da                	cmp    %bl,%dl
801045c1:	75 19                	jne    801045dc <strncmp+0x5c>
801045c3:	39 c7                	cmp    %eax,%edi
    n--, p++, q++;
801045c5:	8d 4e 01             	lea    0x1(%esi),%ecx
}

int
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
801045c8:	75 e6                	jne    801045b0 <strncmp+0x30>
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
}
801045ca:	5b                   	pop    %ebx
strncmp(const char *p, const char *q, uint n)
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
801045cb:	31 c0                	xor    %eax,%eax
  return (uchar)*p - (uchar)*q;
}
801045cd:	5e                   	pop    %esi
801045ce:	5f                   	pop    %edi
801045cf:	5d                   	pop    %ebp
801045d0:	c3                   	ret    
801045d1:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801045d8:	0f b6 5e 01          	movzbl 0x1(%esi),%ebx
{
  while(n > 0 && *p && *p == *q)
    n--, p++, q++;
  if(n == 0)
    return 0;
  return (uchar)*p - (uchar)*q;
801045dc:	0f b6 c2             	movzbl %dl,%eax
801045df:	29 d8                	sub    %ebx,%eax
}
801045e1:	5b                   	pop    %ebx
801045e2:	5e                   	pop    %esi
801045e3:	5f                   	pop    %edi
801045e4:	5d                   	pop    %ebp
801045e5:	c3                   	ret    
801045e6:	8d 76 00             	lea    0x0(%esi),%esi
801045e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801045f0 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
801045f0:	55                   	push   %ebp
801045f1:	89 e5                	mov    %esp,%ebp
801045f3:	56                   	push   %esi
801045f4:	53                   	push   %ebx
801045f5:	8b 45 08             	mov    0x8(%ebp),%eax
801045f8:	8b 5d 0c             	mov    0xc(%ebp),%ebx
801045fb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
801045fe:	89 c2                	mov    %eax,%edx
80104600:	eb 19                	jmp    8010461b <strncpy+0x2b>
80104602:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104608:	83 c3 01             	add    $0x1,%ebx
8010460b:	0f b6 4b ff          	movzbl -0x1(%ebx),%ecx
8010460f:	83 c2 01             	add    $0x1,%edx
80104612:	84 c9                	test   %cl,%cl
80104614:	88 4a ff             	mov    %cl,-0x1(%edx)
80104617:	74 09                	je     80104622 <strncpy+0x32>
80104619:	89 f1                	mov    %esi,%ecx
8010461b:	85 c9                	test   %ecx,%ecx
8010461d:	8d 71 ff             	lea    -0x1(%ecx),%esi
80104620:	7f e6                	jg     80104608 <strncpy+0x18>
    ;
  while(n-- > 0)
80104622:	31 c9                	xor    %ecx,%ecx
80104624:	85 f6                	test   %esi,%esi
80104626:	7e 17                	jle    8010463f <strncpy+0x4f>
80104628:	90                   	nop
80104629:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    *s++ = 0;
80104630:	c6 04 0a 00          	movb   $0x0,(%edx,%ecx,1)
80104634:	89 f3                	mov    %esi,%ebx
80104636:	83 c1 01             	add    $0x1,%ecx
80104639:	29 cb                	sub    %ecx,%ebx
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    ;
  while(n-- > 0)
8010463b:	85 db                	test   %ebx,%ebx
8010463d:	7f f1                	jg     80104630 <strncpy+0x40>
    *s++ = 0;
  return os;
}
8010463f:	5b                   	pop    %ebx
80104640:	5e                   	pop    %esi
80104641:	5d                   	pop    %ebp
80104642:	c3                   	ret    
80104643:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104649:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104650 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
80104650:	55                   	push   %ebp
80104651:	89 e5                	mov    %esp,%ebp
80104653:	56                   	push   %esi
80104654:	53                   	push   %ebx
80104655:	8b 4d 10             	mov    0x10(%ebp),%ecx
80104658:	8b 45 08             	mov    0x8(%ebp),%eax
8010465b:	8b 55 0c             	mov    0xc(%ebp),%edx
  char *os;

  os = s;
  if(n <= 0)
8010465e:	85 c9                	test   %ecx,%ecx
80104660:	7e 26                	jle    80104688 <safestrcpy+0x38>
80104662:	8d 74 0a ff          	lea    -0x1(%edx,%ecx,1),%esi
80104666:	89 c1                	mov    %eax,%ecx
80104668:	eb 17                	jmp    80104681 <safestrcpy+0x31>
8010466a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
80104670:	83 c2 01             	add    $0x1,%edx
80104673:	0f b6 5a ff          	movzbl -0x1(%edx),%ebx
80104677:	83 c1 01             	add    $0x1,%ecx
8010467a:	84 db                	test   %bl,%bl
8010467c:	88 59 ff             	mov    %bl,-0x1(%ecx)
8010467f:	74 04                	je     80104685 <safestrcpy+0x35>
80104681:	39 f2                	cmp    %esi,%edx
80104683:	75 eb                	jne    80104670 <safestrcpy+0x20>
    ;
  *s = 0;
80104685:	c6 01 00             	movb   $0x0,(%ecx)
  return os;
}
80104688:	5b                   	pop    %ebx
80104689:	5e                   	pop    %esi
8010468a:	5d                   	pop    %ebp
8010468b:	c3                   	ret    
8010468c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104690 <strlen>:

int
strlen(const char *s)
{
80104690:	55                   	push   %ebp
  int n;

  for(n = 0; s[n]; n++)
80104691:	31 c0                	xor    %eax,%eax
  return os;
}

int
strlen(const char *s)
{
80104693:	89 e5                	mov    %esp,%ebp
80104695:	8b 55 08             	mov    0x8(%ebp),%edx
  int n;

  for(n = 0; s[n]; n++)
80104698:	80 3a 00             	cmpb   $0x0,(%edx)
8010469b:	74 0c                	je     801046a9 <strlen+0x19>
8010469d:	8d 76 00             	lea    0x0(%esi),%esi
801046a0:	83 c0 01             	add    $0x1,%eax
801046a3:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
801046a7:	75 f7                	jne    801046a0 <strlen+0x10>
    ;
  return n;
}
801046a9:	5d                   	pop    %ebp
801046aa:	c3                   	ret    

801046ab <swtch>:
# a struct context, and save its address in *old.
# Switch stacks to new and pop previously-saved registers.

.globl swtch
swtch:
  movl 4(%esp), %eax
801046ab:	8b 44 24 04          	mov    0x4(%esp),%eax
  movl 8(%esp), %edx
801046af:	8b 54 24 08          	mov    0x8(%esp),%edx

  # Save old callee-saved registers
  pushl %ebp
801046b3:	55                   	push   %ebp
  pushl %ebx
801046b4:	53                   	push   %ebx
  pushl %esi
801046b5:	56                   	push   %esi
  pushl %edi
801046b6:	57                   	push   %edi

  # Switch stacks
  movl %esp, (%eax)
801046b7:	89 20                	mov    %esp,(%eax)
  movl %edx, %esp
801046b9:	89 d4                	mov    %edx,%esp

  # Load new callee-saved registers
  popl %edi
801046bb:	5f                   	pop    %edi
  popl %esi
801046bc:	5e                   	pop    %esi
  popl %ebx
801046bd:	5b                   	pop    %ebx
  popl %ebp
801046be:	5d                   	pop    %ebp
  ret
801046bf:	c3                   	ret    

801046c0 <fetchint>:
// to a saved program counter, and then the first argument.

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
801046c0:	55                   	push   %ebp
801046c1:	89 e5                	mov    %esp,%ebp
801046c3:	53                   	push   %ebx
801046c4:	83 ec 04             	sub    $0x4,%esp
801046c7:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct proc *curproc = myproc();
801046ca:	e8 d1 f0 ff ff       	call   801037a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
801046cf:	8b 00                	mov    (%eax),%eax
801046d1:	39 d8                	cmp    %ebx,%eax
801046d3:	76 1b                	jbe    801046f0 <fetchint+0x30>
801046d5:	8d 53 04             	lea    0x4(%ebx),%edx
801046d8:	39 d0                	cmp    %edx,%eax
801046da:	72 14                	jb     801046f0 <fetchint+0x30>
    return -1;
  *ip = *(int*)(addr);
801046dc:	8b 45 0c             	mov    0xc(%ebp),%eax
801046df:	8b 13                	mov    (%ebx),%edx
801046e1:	89 10                	mov    %edx,(%eax)
  return 0;
801046e3:	31 c0                	xor    %eax,%eax
}
801046e5:	83 c4 04             	add    $0x4,%esp
801046e8:	5b                   	pop    %ebx
801046e9:	5d                   	pop    %ebp
801046ea:	c3                   	ret    
801046eb:	90                   	nop
801046ec:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801046f0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801046f5:	eb ee                	jmp    801046e5 <fetchint+0x25>
801046f7:	89 f6                	mov    %esi,%esi
801046f9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104700 <fetchstr>:
// Fetch the nul-terminated string at addr from the current process.
// Doesn't actually copy the string - just sets *pp to point at it.
// Returns length of string, not including nul.
int
fetchstr(uint addr, char **pp)
{
80104700:	55                   	push   %ebp
80104701:	89 e5                	mov    %esp,%ebp
80104703:	53                   	push   %ebx
80104704:	83 ec 04             	sub    $0x4,%esp
80104707:	8b 5d 08             	mov    0x8(%ebp),%ebx
  char *s, *ep;
  struct proc *curproc = myproc();
8010470a:	e8 91 f0 ff ff       	call   801037a0 <myproc>

  if(addr >= curproc->sz)
8010470f:	39 18                	cmp    %ebx,(%eax)
80104711:	76 29                	jbe    8010473c <fetchstr+0x3c>
    return -1;
  *pp = (char*)addr;
80104713:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80104716:	89 da                	mov    %ebx,%edx
80104718:	89 19                	mov    %ebx,(%ecx)
  ep = (char*)curproc->sz;
8010471a:	8b 00                	mov    (%eax),%eax
  for(s = *pp; s < ep; s++){
8010471c:	39 c3                	cmp    %eax,%ebx
8010471e:	73 1c                	jae    8010473c <fetchstr+0x3c>
    if(*s == 0)
80104720:	80 3b 00             	cmpb   $0x0,(%ebx)
80104723:	75 10                	jne    80104735 <fetchstr+0x35>
80104725:	eb 29                	jmp    80104750 <fetchstr+0x50>
80104727:	89 f6                	mov    %esi,%esi
80104729:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104730:	80 3a 00             	cmpb   $0x0,(%edx)
80104733:	74 1b                	je     80104750 <fetchstr+0x50>

  if(addr >= curproc->sz)
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
80104735:	83 c2 01             	add    $0x1,%edx
80104738:	39 d0                	cmp    %edx,%eax
8010473a:	77 f4                	ja     80104730 <fetchstr+0x30>
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
8010473c:	83 c4 04             	add    $0x4,%esp
{
  char *s, *ep;
  struct proc *curproc = myproc();

  if(addr >= curproc->sz)
    return -1;
8010473f:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
  }
  return -1;
}
80104744:	5b                   	pop    %ebx
80104745:	5d                   	pop    %ebp
80104746:	c3                   	ret    
80104747:	89 f6                	mov    %esi,%esi
80104749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80104750:	83 c4 04             	add    $0x4,%esp
    return -1;
  *pp = (char*)addr;
  ep = (char*)curproc->sz;
  for(s = *pp; s < ep; s++){
    if(*s == 0)
      return s - *pp;
80104753:	89 d0                	mov    %edx,%eax
80104755:	29 d8                	sub    %ebx,%eax
  }
  return -1;
}
80104757:	5b                   	pop    %ebx
80104758:	5d                   	pop    %ebp
80104759:	c3                   	ret    
8010475a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80104760 <argint>:

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
80104760:	55                   	push   %ebp
80104761:	89 e5                	mov    %esp,%ebp
80104763:	56                   	push   %esi
80104764:	53                   	push   %ebx
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
80104765:	e8 36 f0 ff ff       	call   801037a0 <myproc>
8010476a:	8b 40 20             	mov    0x20(%eax),%eax
8010476d:	8b 55 08             	mov    0x8(%ebp),%edx
80104770:	8b 40 44             	mov    0x44(%eax),%eax
80104773:	8d 1c 90             	lea    (%eax,%edx,4),%ebx

// Fetch the int at addr from the current process.
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();
80104776:	e8 25 f0 ff ff       	call   801037a0 <myproc>

  if(addr >= curproc->sz || addr+4 > curproc->sz)
8010477b:	8b 00                	mov    (%eax),%eax

// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
8010477d:	8d 73 04             	lea    0x4(%ebx),%esi
int
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
80104780:	39 c6                	cmp    %eax,%esi
80104782:	73 1c                	jae    801047a0 <argint+0x40>
80104784:	8d 53 08             	lea    0x8(%ebx),%edx
80104787:	39 d0                	cmp    %edx,%eax
80104789:	72 15                	jb     801047a0 <argint+0x40>
    return -1;
  *ip = *(int*)(addr);
8010478b:	8b 45 0c             	mov    0xc(%ebp),%eax
8010478e:	8b 53 04             	mov    0x4(%ebx),%edx
80104791:	89 10                	mov    %edx,(%eax)
  return 0;
80104793:	31 c0                	xor    %eax,%eax
// Fetch the nth 32-bit system call argument.
int
argint(int n, int *ip)
{
  return fetchint((myproc()->tf->esp) + 4 + 4*n, ip);
}
80104795:	5b                   	pop    %ebx
80104796:	5e                   	pop    %esi
80104797:	5d                   	pop    %ebp
80104798:	c3                   	ret    
80104799:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
fetchint(uint addr, int *ip)
{
  struct proc *curproc = myproc();

  if(addr >= curproc->sz || addr+4 > curproc->sz)
    return -1;
801047a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801047a5:	eb ee                	jmp    80104795 <argint+0x35>
801047a7:	89 f6                	mov    %esi,%esi
801047a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801047b0 <argptr>:
// Fetch the nth word-sized system call argument as a pointer
// to a block of memory of size bytes.  Check that the pointer
// lies within the process address space.
int
argptr(int n, char **pp, int size)
{
801047b0:	55                   	push   %ebp
801047b1:	89 e5                	mov    %esp,%ebp
801047b3:	56                   	push   %esi
801047b4:	53                   	push   %ebx
801047b5:	83 ec 10             	sub    $0x10,%esp
801047b8:	8b 5d 10             	mov    0x10(%ebp),%ebx
  int i;
  struct proc *curproc = myproc();
801047bb:	e8 e0 ef ff ff       	call   801037a0 <myproc>
801047c0:	89 c6                	mov    %eax,%esi
 
  if(argint(n, &i) < 0)
801047c2:	8d 45 f4             	lea    -0xc(%ebp),%eax
801047c5:	83 ec 08             	sub    $0x8,%esp
801047c8:	50                   	push   %eax
801047c9:	ff 75 08             	pushl  0x8(%ebp)
801047cc:	e8 8f ff ff ff       	call   80104760 <argint>
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
801047d1:	c1 e8 1f             	shr    $0x1f,%eax
801047d4:	83 c4 10             	add    $0x10,%esp
801047d7:	84 c0                	test   %al,%al
801047d9:	75 2d                	jne    80104808 <argptr+0x58>
801047db:	89 d8                	mov    %ebx,%eax
801047dd:	c1 e8 1f             	shr    $0x1f,%eax
801047e0:	84 c0                	test   %al,%al
801047e2:	75 24                	jne    80104808 <argptr+0x58>
801047e4:	8b 16                	mov    (%esi),%edx
801047e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
801047e9:	39 c2                	cmp    %eax,%edx
801047eb:	76 1b                	jbe    80104808 <argptr+0x58>
801047ed:	01 c3                	add    %eax,%ebx
801047ef:	39 da                	cmp    %ebx,%edx
801047f1:	72 15                	jb     80104808 <argptr+0x58>
    return -1;
  *pp = (char*)i;
801047f3:	8b 55 0c             	mov    0xc(%ebp),%edx
801047f6:	89 02                	mov    %eax,(%edx)
  return 0;
801047f8:	31 c0                	xor    %eax,%eax
}
801047fa:	8d 65 f8             	lea    -0x8(%ebp),%esp
801047fd:	5b                   	pop    %ebx
801047fe:	5e                   	pop    %esi
801047ff:	5d                   	pop    %ebp
80104800:	c3                   	ret    
80104801:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct proc *curproc = myproc();
 
  if(argint(n, &i) < 0)
    return -1;
  if(size < 0 || (uint)i >= curproc->sz || (uint)i+size > curproc->sz)
    return -1;
80104808:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010480d:	eb eb                	jmp    801047fa <argptr+0x4a>
8010480f:	90                   	nop

80104810 <argstr>:
// Check that the pointer is valid and the string is nul-terminated.
// (There is no shared writable memory, so the string can't change
// between this check and being used by the kernel.)
int
argstr(int n, char **pp)
{
80104810:	55                   	push   %ebp
80104811:	89 e5                	mov    %esp,%ebp
80104813:	83 ec 20             	sub    $0x20,%esp
  int addr;
  if(argint(n, &addr) < 0)
80104816:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104819:	50                   	push   %eax
8010481a:	ff 75 08             	pushl  0x8(%ebp)
8010481d:	e8 3e ff ff ff       	call   80104760 <argint>
80104822:	83 c4 10             	add    $0x10,%esp
80104825:	85 c0                	test   %eax,%eax
80104827:	78 17                	js     80104840 <argstr+0x30>
    return -1;
  return fetchstr(addr, pp);
80104829:	83 ec 08             	sub    $0x8,%esp
8010482c:	ff 75 0c             	pushl  0xc(%ebp)
8010482f:	ff 75 f4             	pushl  -0xc(%ebp)
80104832:	e8 c9 fe ff ff       	call   80104700 <fetchstr>
80104837:	83 c4 10             	add    $0x10,%esp
}
8010483a:	c9                   	leave  
8010483b:	c3                   	ret    
8010483c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
int
argstr(int n, char **pp)
{
  int addr;
  if(argint(n, &addr) < 0)
    return -1;
80104840:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fetchstr(addr, pp);
}
80104845:	c9                   	leave  
80104846:	c3                   	ret    
80104847:	89 f6                	mov    %esi,%esi
80104849:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104850 <syscall>:
[SYS_trace]   sys_trace,
};

void
syscall(void)
{
80104850:	55                   	push   %ebp
80104851:	89 e5                	mov    %esp,%ebp
80104853:	56                   	push   %esi
80104854:	53                   	push   %ebx
  int num;
  struct proc *curproc = myproc();
80104855:	e8 46 ef ff ff       	call   801037a0 <myproc>
8010485a:	89 c3                	mov    %eax,%ebx

  num = curproc->tf->eax;
8010485c:	8b 40 20             	mov    0x20(%eax),%eax
8010485f:	8b 40 1c             	mov    0x1c(%eax),%eax
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
80104862:	8d 50 ff             	lea    -0x1(%eax),%edx
80104865:	83 fa 15             	cmp    $0x15,%edx
80104868:	77 26                	ja     80104890 <syscall+0x40>
8010486a:	8b 34 85 40 77 10 80 	mov    -0x7fef88c0(,%eax,4),%esi
80104871:	85 f6                	test   %esi,%esi
80104873:	74 1b                	je     80104890 <syscall+0x40>
    myproc()->numCalls++;
80104875:	e8 26 ef ff ff       	call   801037a0 <myproc>
8010487a:	83 40 08 01          	addl   $0x1,0x8(%eax)
    curproc->tf->eax = syscalls[num]();
8010487e:	8b 5b 20             	mov    0x20(%ebx),%ebx
80104881:	ff d6                	call   *%esi
80104883:	89 43 1c             	mov    %eax,0x1c(%ebx)
  } else {
    cprintf("%d %s: unknown sys call %d\n",
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
  }
}
80104886:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104889:	5b                   	pop    %ebx
8010488a:	5e                   	pop    %esi
8010488b:	5d                   	pop    %ebp
8010488c:	c3                   	ret    
8010488d:	8d 76 00             	lea    0x0(%esi),%esi
  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    myproc()->numCalls++;
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104890:	50                   	push   %eax
            curproc->pid, curproc->name, num);
80104891:	8d 43 74             	lea    0x74(%ebx),%eax
  num = curproc->tf->eax;
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    myproc()->numCalls++;
    curproc->tf->eax = syscalls[num]();
  } else {
    cprintf("%d %s: unknown sys call %d\n",
80104894:	50                   	push   %eax
80104895:	ff 73 18             	pushl  0x18(%ebx)
80104898:	68 11 77 10 80       	push   $0x80107711
8010489d:	e8 be bd ff ff       	call   80100660 <cprintf>
            curproc->pid, curproc->name, num);
    curproc->tf->eax = -1;
801048a2:	8b 43 20             	mov    0x20(%ebx),%eax
801048a5:	83 c4 10             	add    $0x10,%esp
801048a8:	c7 40 1c ff ff ff ff 	movl   $0xffffffff,0x1c(%eax)
  }
}
801048af:	8d 65 f8             	lea    -0x8(%ebp),%esp
801048b2:	5b                   	pop    %ebx
801048b3:	5e                   	pop    %esi
801048b4:	5d                   	pop    %ebp
801048b5:	c3                   	ret    
801048b6:	66 90                	xchg   %ax,%ax
801048b8:	66 90                	xchg   %ax,%ax
801048ba:	66 90                	xchg   %ax,%ax
801048bc:	66 90                	xchg   %ax,%ax
801048be:	66 90                	xchg   %ax,%ax

801048c0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048c0:	55                   	push   %ebp
801048c1:	89 e5                	mov    %esp,%ebp
801048c3:	57                   	push   %edi
801048c4:	56                   	push   %esi
801048c5:	53                   	push   %ebx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048c6:	8d 75 da             	lea    -0x26(%ebp),%esi
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048c9:	83 ec 44             	sub    $0x44,%esp
801048cc:	89 4d c0             	mov    %ecx,-0x40(%ebp)
801048cf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048d2:	56                   	push   %esi
801048d3:	50                   	push   %eax
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
801048d4:	89 55 c4             	mov    %edx,-0x3c(%ebp)
801048d7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
801048da:	e8 01 d6 ff ff       	call   80101ee0 <nameiparent>
801048df:	83 c4 10             	add    $0x10,%esp
801048e2:	85 c0                	test   %eax,%eax
801048e4:	0f 84 f6 00 00 00    	je     801049e0 <create+0x120>
    return 0;
  ilock(dp);
801048ea:	83 ec 0c             	sub    $0xc,%esp
801048ed:	89 c7                	mov    %eax,%edi
801048ef:	50                   	push   %eax
801048f0:	e8 7b cd ff ff       	call   80101670 <ilock>

  if((ip = dirlookup(dp, name, &off)) != 0){
801048f5:	8d 45 d4             	lea    -0x2c(%ebp),%eax
801048f8:	83 c4 0c             	add    $0xc,%esp
801048fb:	50                   	push   %eax
801048fc:	56                   	push   %esi
801048fd:	57                   	push   %edi
801048fe:	e8 9d d2 ff ff       	call   80101ba0 <dirlookup>
80104903:	83 c4 10             	add    $0x10,%esp
80104906:	85 c0                	test   %eax,%eax
80104908:	89 c3                	mov    %eax,%ebx
8010490a:	74 54                	je     80104960 <create+0xa0>
    iunlockput(dp);
8010490c:	83 ec 0c             	sub    $0xc,%esp
8010490f:	57                   	push   %edi
80104910:	e8 eb cf ff ff       	call   80101900 <iunlockput>
    ilock(ip);
80104915:	89 1c 24             	mov    %ebx,(%esp)
80104918:	e8 53 cd ff ff       	call   80101670 <ilock>
    if(type == T_FILE && ip->type == T_FILE)
8010491d:	83 c4 10             	add    $0x10,%esp
80104920:	66 83 7d c4 02       	cmpw   $0x2,-0x3c(%ebp)
80104925:	75 19                	jne    80104940 <create+0x80>
80104927:	66 83 7b 50 02       	cmpw   $0x2,0x50(%ebx)
8010492c:	89 d8                	mov    %ebx,%eax
8010492e:	75 10                	jne    80104940 <create+0x80>
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104930:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104933:	5b                   	pop    %ebx
80104934:	5e                   	pop    %esi
80104935:	5f                   	pop    %edi
80104936:	5d                   	pop    %ebp
80104937:	c3                   	ret    
80104938:	90                   	nop
80104939:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  if((ip = dirlookup(dp, name, &off)) != 0){
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
80104940:	83 ec 0c             	sub    $0xc,%esp
80104943:	53                   	push   %ebx
80104944:	e8 b7 cf ff ff       	call   80101900 <iunlockput>
    return 0;
80104949:	83 c4 10             	add    $0x10,%esp
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
8010494c:	8d 65 f4             	lea    -0xc(%ebp),%esp
    iunlockput(dp);
    ilock(ip);
    if(type == T_FILE && ip->type == T_FILE)
      return ip;
    iunlockput(ip);
    return 0;
8010494f:	31 c0                	xor    %eax,%eax
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
}
80104951:	5b                   	pop    %ebx
80104952:	5e                   	pop    %esi
80104953:	5f                   	pop    %edi
80104954:	5d                   	pop    %ebp
80104955:	c3                   	ret    
80104956:	8d 76 00             	lea    0x0(%esi),%esi
80104959:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      return ip;
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
80104960:	0f bf 45 c4          	movswl -0x3c(%ebp),%eax
80104964:	83 ec 08             	sub    $0x8,%esp
80104967:	50                   	push   %eax
80104968:	ff 37                	pushl  (%edi)
8010496a:	e8 91 cb ff ff       	call   80101500 <ialloc>
8010496f:	83 c4 10             	add    $0x10,%esp
80104972:	85 c0                	test   %eax,%eax
80104974:	89 c3                	mov    %eax,%ebx
80104976:	0f 84 cc 00 00 00    	je     80104a48 <create+0x188>
    panic("create: ialloc");

  ilock(ip);
8010497c:	83 ec 0c             	sub    $0xc,%esp
8010497f:	50                   	push   %eax
80104980:	e8 eb cc ff ff       	call   80101670 <ilock>
  ip->major = major;
80104985:	0f b7 45 c0          	movzwl -0x40(%ebp),%eax
80104989:	66 89 43 52          	mov    %ax,0x52(%ebx)
  ip->minor = minor;
8010498d:	0f b7 45 bc          	movzwl -0x44(%ebp),%eax
80104991:	66 89 43 54          	mov    %ax,0x54(%ebx)
  ip->nlink = 1;
80104995:	b8 01 00 00 00       	mov    $0x1,%eax
8010499a:	66 89 43 56          	mov    %ax,0x56(%ebx)
  iupdate(ip);
8010499e:	89 1c 24             	mov    %ebx,(%esp)
801049a1:	e8 1a cc ff ff       	call   801015c0 <iupdate>

  if(type == T_DIR){  // Create . and .. entries.
801049a6:	83 c4 10             	add    $0x10,%esp
801049a9:	66 83 7d c4 01       	cmpw   $0x1,-0x3c(%ebp)
801049ae:	74 40                	je     801049f0 <create+0x130>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
      panic("create dots");
  }

  if(dirlink(dp, name, ip->inum) < 0)
801049b0:	83 ec 04             	sub    $0x4,%esp
801049b3:	ff 73 04             	pushl  0x4(%ebx)
801049b6:	56                   	push   %esi
801049b7:	57                   	push   %edi
801049b8:	e8 43 d4 ff ff       	call   80101e00 <dirlink>
801049bd:	83 c4 10             	add    $0x10,%esp
801049c0:	85 c0                	test   %eax,%eax
801049c2:	78 77                	js     80104a3b <create+0x17b>
    panic("create: dirlink");

  iunlockput(dp);
801049c4:	83 ec 0c             	sub    $0xc,%esp
801049c7:	57                   	push   %edi
801049c8:	e8 33 cf ff ff       	call   80101900 <iunlockput>

  return ip;
801049cd:	83 c4 10             	add    $0x10,%esp
}
801049d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");

  iunlockput(dp);

  return ip;
801049d3:	89 d8                	mov    %ebx,%eax
}
801049d5:	5b                   	pop    %ebx
801049d6:	5e                   	pop    %esi
801049d7:	5f                   	pop    %edi
801049d8:	5d                   	pop    %ebp
801049d9:	c3                   	ret    
801049da:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
  uint off;
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    return 0;
801049e0:	31 c0                	xor    %eax,%eax
801049e2:	e9 49 ff ff ff       	jmp    80104930 <create+0x70>
801049e7:	89 f6                	mov    %esi,%esi
801049e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  ip->minor = minor;
  ip->nlink = 1;
  iupdate(ip);

  if(type == T_DIR){  // Create . and .. entries.
    dp->nlink++;  // for ".."
801049f0:	66 83 47 56 01       	addw   $0x1,0x56(%edi)
    iupdate(dp);
801049f5:	83 ec 0c             	sub    $0xc,%esp
801049f8:	57                   	push   %edi
801049f9:	e8 c2 cb ff ff       	call   801015c0 <iupdate>
    // No ip->nlink++ for ".": avoid cyclic ref count.
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
801049fe:	83 c4 0c             	add    $0xc,%esp
80104a01:	ff 73 04             	pushl  0x4(%ebx)
80104a04:	68 b8 77 10 80       	push   $0x801077b8
80104a09:	53                   	push   %ebx
80104a0a:	e8 f1 d3 ff ff       	call   80101e00 <dirlink>
80104a0f:	83 c4 10             	add    $0x10,%esp
80104a12:	85 c0                	test   %eax,%eax
80104a14:	78 18                	js     80104a2e <create+0x16e>
80104a16:	83 ec 04             	sub    $0x4,%esp
80104a19:	ff 77 04             	pushl  0x4(%edi)
80104a1c:	68 b7 77 10 80       	push   $0x801077b7
80104a21:	53                   	push   %ebx
80104a22:	e8 d9 d3 ff ff       	call   80101e00 <dirlink>
80104a27:	83 c4 10             	add    $0x10,%esp
80104a2a:	85 c0                	test   %eax,%eax
80104a2c:	79 82                	jns    801049b0 <create+0xf0>
      panic("create dots");
80104a2e:	83 ec 0c             	sub    $0xc,%esp
80104a31:	68 ab 77 10 80       	push   $0x801077ab
80104a36:	e8 35 b9 ff ff       	call   80100370 <panic>
  }

  if(dirlink(dp, name, ip->inum) < 0)
    panic("create: dirlink");
80104a3b:	83 ec 0c             	sub    $0xc,%esp
80104a3e:	68 ba 77 10 80       	push   $0x801077ba
80104a43:	e8 28 b9 ff ff       	call   80100370 <panic>
    iunlockput(ip);
    return 0;
  }

  if((ip = ialloc(dp->dev, type)) == 0)
    panic("create: ialloc");
80104a48:	83 ec 0c             	sub    $0xc,%esp
80104a4b:	68 9c 77 10 80       	push   $0x8010779c
80104a50:	e8 1b b9 ff ff       	call   80100370 <panic>
80104a55:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80104a59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104a60 <argfd.constprop.0>:
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a60:	55                   	push   %ebp
80104a61:	89 e5                	mov    %esp,%ebp
80104a63:	56                   	push   %esi
80104a64:	53                   	push   %ebx
80104a65:	89 c6                	mov    %eax,%esi
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a67:	8d 45 f4             	lea    -0xc(%ebp),%eax
#include "fcntl.h"

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
80104a6a:	89 d3                	mov    %edx,%ebx
80104a6c:	83 ec 18             	sub    $0x18,%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
80104a6f:	50                   	push   %eax
80104a70:	6a 00                	push   $0x0
80104a72:	e8 e9 fc ff ff       	call   80104760 <argint>
80104a77:	83 c4 10             	add    $0x10,%esp
80104a7a:	85 c0                	test   %eax,%eax
80104a7c:	78 32                	js     80104ab0 <argfd.constprop.0+0x50>
    return -1;
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
80104a7e:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
80104a82:	77 2c                	ja     80104ab0 <argfd.constprop.0+0x50>
80104a84:	e8 17 ed ff ff       	call   801037a0 <myproc>
80104a89:	8b 55 f4             	mov    -0xc(%ebp),%edx
80104a8c:	8b 44 90 30          	mov    0x30(%eax,%edx,4),%eax
80104a90:	85 c0                	test   %eax,%eax
80104a92:	74 1c                	je     80104ab0 <argfd.constprop.0+0x50>
    return -1;
  if(pfd)
80104a94:	85 f6                	test   %esi,%esi
80104a96:	74 02                	je     80104a9a <argfd.constprop.0+0x3a>
    *pfd = fd;
80104a98:	89 16                	mov    %edx,(%esi)
  if(pf)
80104a9a:	85 db                	test   %ebx,%ebx
80104a9c:	74 22                	je     80104ac0 <argfd.constprop.0+0x60>
    *pf = f;
80104a9e:	89 03                	mov    %eax,(%ebx)
  return 0;
80104aa0:	31 c0                	xor    %eax,%eax
}
80104aa2:	8d 65 f8             	lea    -0x8(%ebp),%esp
80104aa5:	5b                   	pop    %ebx
80104aa6:	5e                   	pop    %esi
80104aa7:	5d                   	pop    %ebp
80104aa8:	c3                   	ret    
80104aa9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80104ab0:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  int fd;
  struct file *f;

  if(argint(n, &fd) < 0)
    return -1;
80104ab3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
}
80104ab8:	5b                   	pop    %ebx
80104ab9:	5e                   	pop    %esi
80104aba:	5d                   	pop    %ebp
80104abb:	c3                   	ret    
80104abc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    return -1;
  if(pfd)
    *pfd = fd;
  if(pf)
    *pf = f;
  return 0;
80104ac0:	31 c0                	xor    %eax,%eax
80104ac2:	eb de                	jmp    80104aa2 <argfd.constprop.0+0x42>
80104ac4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104aca:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104ad0 <sys_dup>:
  return -1;
}

int
sys_dup(void)
{
80104ad0:	55                   	push   %ebp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ad1:	31 c0                	xor    %eax,%eax
  return -1;
}

int
sys_dup(void)
{
80104ad3:	89 e5                	mov    %esp,%ebp
80104ad5:	56                   	push   %esi
80104ad6:	53                   	push   %ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104ad7:	8d 55 f4             	lea    -0xc(%ebp),%edx
  return -1;
}

int
sys_dup(void)
{
80104ada:	83 ec 10             	sub    $0x10,%esp
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
80104add:	e8 7e ff ff ff       	call   80104a60 <argfd.constprop.0>
80104ae2:	85 c0                	test   %eax,%eax
80104ae4:	78 1a                	js     80104b00 <sys_dup+0x30>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104ae6:	31 db                	xor    %ebx,%ebx
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
80104ae8:	8b 75 f4             	mov    -0xc(%ebp),%esi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80104aeb:	e8 b0 ec ff ff       	call   801037a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80104af0:	8b 54 98 30          	mov    0x30(%eax,%ebx,4),%edx
80104af4:	85 d2                	test   %edx,%edx
80104af6:	74 18                	je     80104b10 <sys_dup+0x40>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80104af8:	83 c3 01             	add    $0x1,%ebx
80104afb:	83 fb 10             	cmp    $0x10,%ebx
80104afe:	75 f0                	jne    80104af0 <sys_dup+0x20>
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b00:	8d 65 f8             	lea    -0x8(%ebp),%esp
{
  struct file *f;
  int fd;

  if(argfd(0, 0, &f) < 0)
    return -1;
80104b03:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
}
80104b08:	5b                   	pop    %ebx
80104b09:	5e                   	pop    %esi
80104b0a:	5d                   	pop    %ebp
80104b0b:	c3                   	ret    
80104b0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80104b10:	89 74 98 30          	mov    %esi,0x30(%eax,%ebx,4)

  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
80104b14:	83 ec 0c             	sub    $0xc,%esp
80104b17:	ff 75 f4             	pushl  -0xc(%ebp)
80104b1a:	e8 c1 c2 ff ff       	call   80100de0 <filedup>
  return fd;
80104b1f:	83 c4 10             	add    $0x10,%esp
}
80104b22:	8d 65 f8             	lea    -0x8(%ebp),%esp
  if(argfd(0, 0, &f) < 0)
    return -1;
  if((fd=fdalloc(f)) < 0)
    return -1;
  filedup(f);
  return fd;
80104b25:	89 d8                	mov    %ebx,%eax
}
80104b27:	5b                   	pop    %ebx
80104b28:	5e                   	pop    %esi
80104b29:	5d                   	pop    %ebp
80104b2a:	c3                   	ret    
80104b2b:	90                   	nop
80104b2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80104b30 <sys_read>:

int
sys_read(void)
{
80104b30:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b31:	31 c0                	xor    %eax,%eax
  return fd;
}

int
sys_read(void)
{
80104b33:	89 e5                	mov    %esp,%ebp
80104b35:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104b38:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104b3b:	e8 20 ff ff ff       	call   80104a60 <argfd.constprop.0>
80104b40:	85 c0                	test   %eax,%eax
80104b42:	78 4c                	js     80104b90 <sys_read+0x60>
80104b44:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104b47:	83 ec 08             	sub    $0x8,%esp
80104b4a:	50                   	push   %eax
80104b4b:	6a 02                	push   $0x2
80104b4d:	e8 0e fc ff ff       	call   80104760 <argint>
80104b52:	83 c4 10             	add    $0x10,%esp
80104b55:	85 c0                	test   %eax,%eax
80104b57:	78 37                	js     80104b90 <sys_read+0x60>
80104b59:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104b5c:	83 ec 04             	sub    $0x4,%esp
80104b5f:	ff 75 f0             	pushl  -0x10(%ebp)
80104b62:	50                   	push   %eax
80104b63:	6a 01                	push   $0x1
80104b65:	e8 46 fc ff ff       	call   801047b0 <argptr>
80104b6a:	83 c4 10             	add    $0x10,%esp
80104b6d:	85 c0                	test   %eax,%eax
80104b6f:	78 1f                	js     80104b90 <sys_read+0x60>
    return -1;
  return fileread(f, p, n);
80104b71:	83 ec 04             	sub    $0x4,%esp
80104b74:	ff 75 f0             	pushl  -0x10(%ebp)
80104b77:	ff 75 f4             	pushl  -0xc(%ebp)
80104b7a:	ff 75 ec             	pushl  -0x14(%ebp)
80104b7d:	e8 ce c3 ff ff       	call   80100f50 <fileread>
80104b82:	83 c4 10             	add    $0x10,%esp
}
80104b85:	c9                   	leave  
80104b86:	c3                   	ret    
80104b87:	89 f6                	mov    %esi,%esi
80104b89:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104b90:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return fileread(f, p, n);
}
80104b95:	c9                   	leave  
80104b96:	c3                   	ret    
80104b97:	89 f6                	mov    %esi,%esi
80104b99:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104ba0 <sys_write>:

int
sys_write(void)
{
80104ba0:	55                   	push   %ebp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ba1:	31 c0                	xor    %eax,%eax
  return fileread(f, p, n);
}

int
sys_write(void)
{
80104ba3:	89 e5                	mov    %esp,%ebp
80104ba5:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
80104ba8:	8d 55 ec             	lea    -0x14(%ebp),%edx
80104bab:	e8 b0 fe ff ff       	call   80104a60 <argfd.constprop.0>
80104bb0:	85 c0                	test   %eax,%eax
80104bb2:	78 4c                	js     80104c00 <sys_write+0x60>
80104bb4:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104bb7:	83 ec 08             	sub    $0x8,%esp
80104bba:	50                   	push   %eax
80104bbb:	6a 02                	push   $0x2
80104bbd:	e8 9e fb ff ff       	call   80104760 <argint>
80104bc2:	83 c4 10             	add    $0x10,%esp
80104bc5:	85 c0                	test   %eax,%eax
80104bc7:	78 37                	js     80104c00 <sys_write+0x60>
80104bc9:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104bcc:	83 ec 04             	sub    $0x4,%esp
80104bcf:	ff 75 f0             	pushl  -0x10(%ebp)
80104bd2:	50                   	push   %eax
80104bd3:	6a 01                	push   $0x1
80104bd5:	e8 d6 fb ff ff       	call   801047b0 <argptr>
80104bda:	83 c4 10             	add    $0x10,%esp
80104bdd:	85 c0                	test   %eax,%eax
80104bdf:	78 1f                	js     80104c00 <sys_write+0x60>
    return -1;
  return filewrite(f, p, n);
80104be1:	83 ec 04             	sub    $0x4,%esp
80104be4:	ff 75 f0             	pushl  -0x10(%ebp)
80104be7:	ff 75 f4             	pushl  -0xc(%ebp)
80104bea:	ff 75 ec             	pushl  -0x14(%ebp)
80104bed:	e8 ee c3 ff ff       	call   80100fe0 <filewrite>
80104bf2:	83 c4 10             	add    $0x10,%esp
}
80104bf5:	c9                   	leave  
80104bf6:	c3                   	ret    
80104bf7:	89 f6                	mov    %esi,%esi
80104bf9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  struct file *f;
  int n;
  char *p;

  if(argfd(0, 0, &f) < 0 || argint(2, &n) < 0 || argptr(1, &p, n) < 0)
    return -1;
80104c00:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filewrite(f, p, n);
}
80104c05:	c9                   	leave  
80104c06:	c3                   	ret    
80104c07:	89 f6                	mov    %esi,%esi
80104c09:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c10 <sys_close>:

int
sys_close(void)
{
80104c10:	55                   	push   %ebp
80104c11:	89 e5                	mov    %esp,%ebp
80104c13:	83 ec 18             	sub    $0x18,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
80104c16:	8d 55 f4             	lea    -0xc(%ebp),%edx
80104c19:	8d 45 f0             	lea    -0x10(%ebp),%eax
80104c1c:	e8 3f fe ff ff       	call   80104a60 <argfd.constprop.0>
80104c21:	85 c0                	test   %eax,%eax
80104c23:	78 2b                	js     80104c50 <sys_close+0x40>
    return -1;
  myproc()->ofile[fd] = 0;
80104c25:	e8 76 eb ff ff       	call   801037a0 <myproc>
80104c2a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  fileclose(f);
80104c2d:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
  myproc()->ofile[fd] = 0;
80104c30:	c7 44 90 30 00 00 00 	movl   $0x0,0x30(%eax,%edx,4)
80104c37:	00 
  fileclose(f);
80104c38:	ff 75 f4             	pushl  -0xc(%ebp)
80104c3b:	e8 f0 c1 ff ff       	call   80100e30 <fileclose>
  return 0;
80104c40:	83 c4 10             	add    $0x10,%esp
80104c43:	31 c0                	xor    %eax,%eax
}
80104c45:	c9                   	leave  
80104c46:	c3                   	ret    
80104c47:	89 f6                	mov    %esi,%esi
80104c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
{
  int fd;
  struct file *f;

  if(argfd(0, &fd, &f) < 0)
    return -1;
80104c50:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  myproc()->ofile[fd] = 0;
  fileclose(f);
  return 0;
}
80104c55:	c9                   	leave  
80104c56:	c3                   	ret    
80104c57:	89 f6                	mov    %esi,%esi
80104c59:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104c60 <sys_fstat>:

int
sys_fstat(void)
{
80104c60:	55                   	push   %ebp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c61:	31 c0                	xor    %eax,%eax
  return 0;
}

int
sys_fstat(void)
{
80104c63:	89 e5                	mov    %esp,%ebp
80104c65:	83 ec 18             	sub    $0x18,%esp
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
80104c68:	8d 55 f0             	lea    -0x10(%ebp),%edx
80104c6b:	e8 f0 fd ff ff       	call   80104a60 <argfd.constprop.0>
80104c70:	85 c0                	test   %eax,%eax
80104c72:	78 2c                	js     80104ca0 <sys_fstat+0x40>
80104c74:	8d 45 f4             	lea    -0xc(%ebp),%eax
80104c77:	83 ec 04             	sub    $0x4,%esp
80104c7a:	6a 14                	push   $0x14
80104c7c:	50                   	push   %eax
80104c7d:	6a 01                	push   $0x1
80104c7f:	e8 2c fb ff ff       	call   801047b0 <argptr>
80104c84:	83 c4 10             	add    $0x10,%esp
80104c87:	85 c0                	test   %eax,%eax
80104c89:	78 15                	js     80104ca0 <sys_fstat+0x40>
    return -1;
  return filestat(f, st);
80104c8b:	83 ec 08             	sub    $0x8,%esp
80104c8e:	ff 75 f4             	pushl  -0xc(%ebp)
80104c91:	ff 75 f0             	pushl  -0x10(%ebp)
80104c94:	e8 67 c2 ff ff       	call   80100f00 <filestat>
80104c99:	83 c4 10             	add    $0x10,%esp
}
80104c9c:	c9                   	leave  
80104c9d:	c3                   	ret    
80104c9e:	66 90                	xchg   %ax,%ax
{
  struct file *f;
  struct stat *st;

  if(argfd(0, 0, &f) < 0 || argptr(1, (void*)&st, sizeof(*st)) < 0)
    return -1;
80104ca0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return filestat(f, st);
}
80104ca5:	c9                   	leave  
80104ca6:	c3                   	ret    
80104ca7:	89 f6                	mov    %esi,%esi
80104ca9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80104cb0 <sys_link>:

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cb0:	55                   	push   %ebp
80104cb1:	89 e5                	mov    %esp,%ebp
80104cb3:	57                   	push   %edi
80104cb4:	56                   	push   %esi
80104cb5:	53                   	push   %ebx
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cb6:	8d 45 d4             	lea    -0x2c(%ebp),%eax
}

// Create the path new as a link to the same inode as old.
int
sys_link(void)
{
80104cb9:	83 ec 34             	sub    $0x34,%esp
  char name[DIRSIZ], *new, *old;
  struct inode *dp, *ip;

  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
80104cbc:	50                   	push   %eax
80104cbd:	6a 00                	push   $0x0
80104cbf:	e8 4c fb ff ff       	call   80104810 <argstr>
80104cc4:	83 c4 10             	add    $0x10,%esp
80104cc7:	85 c0                	test   %eax,%eax
80104cc9:	0f 88 fb 00 00 00    	js     80104dca <sys_link+0x11a>
80104ccf:	8d 45 d0             	lea    -0x30(%ebp),%eax
80104cd2:	83 ec 08             	sub    $0x8,%esp
80104cd5:	50                   	push   %eax
80104cd6:	6a 01                	push   $0x1
80104cd8:	e8 33 fb ff ff       	call   80104810 <argstr>
80104cdd:	83 c4 10             	add    $0x10,%esp
80104ce0:	85 c0                	test   %eax,%eax
80104ce2:	0f 88 e2 00 00 00    	js     80104dca <sys_link+0x11a>
    return -1;

  begin_op();
80104ce8:	e8 63 de ff ff       	call   80102b50 <begin_op>
  if((ip = namei(old)) == 0){
80104ced:	83 ec 0c             	sub    $0xc,%esp
80104cf0:	ff 75 d4             	pushl  -0x2c(%ebp)
80104cf3:	e8 c8 d1 ff ff       	call   80101ec0 <namei>
80104cf8:	83 c4 10             	add    $0x10,%esp
80104cfb:	85 c0                	test   %eax,%eax
80104cfd:	89 c3                	mov    %eax,%ebx
80104cff:	0f 84 f3 00 00 00    	je     80104df8 <sys_link+0x148>
    end_op();
    return -1;
  }

  ilock(ip);
80104d05:	83 ec 0c             	sub    $0xc,%esp
80104d08:	50                   	push   %eax
80104d09:	e8 62 c9 ff ff       	call   80101670 <ilock>
  if(ip->type == T_DIR){
80104d0e:	83 c4 10             	add    $0x10,%esp
80104d11:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104d16:	0f 84 c4 00 00 00    	je     80104de0 <sys_link+0x130>
    iunlockput(ip);
    end_op();
    return -1;
  }

  ip->nlink++;
80104d1c:	66 83 43 56 01       	addw   $0x1,0x56(%ebx)
  iupdate(ip);
80104d21:	83 ec 0c             	sub    $0xc,%esp
  iunlock(ip);

  if((dp = nameiparent(new, name)) == 0)
80104d24:	8d 7d da             	lea    -0x26(%ebp),%edi
    end_op();
    return -1;
  }

  ip->nlink++;
  iupdate(ip);
80104d27:	53                   	push   %ebx
80104d28:	e8 93 c8 ff ff       	call   801015c0 <iupdate>
  iunlock(ip);
80104d2d:	89 1c 24             	mov    %ebx,(%esp)
80104d30:	e8 1b ca ff ff       	call   80101750 <iunlock>

  if((dp = nameiparent(new, name)) == 0)
80104d35:	58                   	pop    %eax
80104d36:	5a                   	pop    %edx
80104d37:	57                   	push   %edi
80104d38:	ff 75 d0             	pushl  -0x30(%ebp)
80104d3b:	e8 a0 d1 ff ff       	call   80101ee0 <nameiparent>
80104d40:	83 c4 10             	add    $0x10,%esp
80104d43:	85 c0                	test   %eax,%eax
80104d45:	89 c6                	mov    %eax,%esi
80104d47:	74 5b                	je     80104da4 <sys_link+0xf4>
    goto bad;
  ilock(dp);
80104d49:	83 ec 0c             	sub    $0xc,%esp
80104d4c:	50                   	push   %eax
80104d4d:	e8 1e c9 ff ff       	call   80101670 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
80104d52:	83 c4 10             	add    $0x10,%esp
80104d55:	8b 03                	mov    (%ebx),%eax
80104d57:	39 06                	cmp    %eax,(%esi)
80104d59:	75 3d                	jne    80104d98 <sys_link+0xe8>
80104d5b:	83 ec 04             	sub    $0x4,%esp
80104d5e:	ff 73 04             	pushl  0x4(%ebx)
80104d61:	57                   	push   %edi
80104d62:	56                   	push   %esi
80104d63:	e8 98 d0 ff ff       	call   80101e00 <dirlink>
80104d68:	83 c4 10             	add    $0x10,%esp
80104d6b:	85 c0                	test   %eax,%eax
80104d6d:	78 29                	js     80104d98 <sys_link+0xe8>
    iunlockput(dp);
    goto bad;
  }
  iunlockput(dp);
80104d6f:	83 ec 0c             	sub    $0xc,%esp
80104d72:	56                   	push   %esi
80104d73:	e8 88 cb ff ff       	call   80101900 <iunlockput>
  iput(ip);
80104d78:	89 1c 24             	mov    %ebx,(%esp)
80104d7b:	e8 20 ca ff ff       	call   801017a0 <iput>

  end_op();
80104d80:	e8 3b de ff ff       	call   80102bc0 <end_op>

  return 0;
80104d85:	83 c4 10             	add    $0x10,%esp
80104d88:	31 c0                	xor    %eax,%eax
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
}
80104d8a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104d8d:	5b                   	pop    %ebx
80104d8e:	5e                   	pop    %esi
80104d8f:	5f                   	pop    %edi
80104d90:	5d                   	pop    %ebp
80104d91:	c3                   	ret    
80104d92:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

  if((dp = nameiparent(new, name)) == 0)
    goto bad;
  ilock(dp);
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    iunlockput(dp);
80104d98:	83 ec 0c             	sub    $0xc,%esp
80104d9b:	56                   	push   %esi
80104d9c:	e8 5f cb ff ff       	call   80101900 <iunlockput>
    goto bad;
80104da1:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  ilock(ip);
80104da4:	83 ec 0c             	sub    $0xc,%esp
80104da7:	53                   	push   %ebx
80104da8:	e8 c3 c8 ff ff       	call   80101670 <ilock>
  ip->nlink--;
80104dad:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104db2:	89 1c 24             	mov    %ebx,(%esp)
80104db5:	e8 06 c8 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104dba:	89 1c 24             	mov    %ebx,(%esp)
80104dbd:	e8 3e cb ff ff       	call   80101900 <iunlockput>
  end_op();
80104dc2:	e8 f9 dd ff ff       	call   80102bc0 <end_op>
  return -1;
80104dc7:	83 c4 10             	add    $0x10,%esp
}
80104dca:	8d 65 f4             	lea    -0xc(%ebp),%esp
  ilock(ip);
  ip->nlink--;
  iupdate(ip);
  iunlockput(ip);
  end_op();
  return -1;
80104dcd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104dd2:	5b                   	pop    %ebx
80104dd3:	5e                   	pop    %esi
80104dd4:	5f                   	pop    %edi
80104dd5:	5d                   	pop    %ebp
80104dd6:	c3                   	ret    
80104dd7:	89 f6                	mov    %esi,%esi
80104dd9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    return -1;
  }

  ilock(ip);
  if(ip->type == T_DIR){
    iunlockput(ip);
80104de0:	83 ec 0c             	sub    $0xc,%esp
80104de3:	53                   	push   %ebx
80104de4:	e8 17 cb ff ff       	call   80101900 <iunlockput>
    end_op();
80104de9:	e8 d2 dd ff ff       	call   80102bc0 <end_op>
    return -1;
80104dee:	83 c4 10             	add    $0x10,%esp
80104df1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104df6:	eb 92                	jmp    80104d8a <sys_link+0xda>
  if(argstr(0, &old) < 0 || argstr(1, &new) < 0)
    return -1;

  begin_op();
  if((ip = namei(old)) == 0){
    end_op();
80104df8:	e8 c3 dd ff ff       	call   80102bc0 <end_op>
    return -1;
80104dfd:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104e02:	eb 86                	jmp    80104d8a <sys_link+0xda>
80104e04:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80104e0a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80104e10 <sys_unlink>:
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e10:	55                   	push   %ebp
80104e11:	89 e5                	mov    %esp,%ebp
80104e13:	57                   	push   %edi
80104e14:	56                   	push   %esi
80104e15:	53                   	push   %ebx
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e16:	8d 45 c0             	lea    -0x40(%ebp),%eax
}

//PAGEBREAK!
int
sys_unlink(void)
{
80104e19:	83 ec 54             	sub    $0x54,%esp
  struct inode *ip, *dp;
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
80104e1c:	50                   	push   %eax
80104e1d:	6a 00                	push   $0x0
80104e1f:	e8 ec f9 ff ff       	call   80104810 <argstr>
80104e24:	83 c4 10             	add    $0x10,%esp
80104e27:	85 c0                	test   %eax,%eax
80104e29:	0f 88 82 01 00 00    	js     80104fb1 <sys_unlink+0x1a1>
    return -1;

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
80104e2f:	8d 5d ca             	lea    -0x36(%ebp),%ebx
  uint off;

  if(argstr(0, &path) < 0)
    return -1;

  begin_op();
80104e32:	e8 19 dd ff ff       	call   80102b50 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
80104e37:	83 ec 08             	sub    $0x8,%esp
80104e3a:	53                   	push   %ebx
80104e3b:	ff 75 c0             	pushl  -0x40(%ebp)
80104e3e:	e8 9d d0 ff ff       	call   80101ee0 <nameiparent>
80104e43:	83 c4 10             	add    $0x10,%esp
80104e46:	85 c0                	test   %eax,%eax
80104e48:	89 45 b4             	mov    %eax,-0x4c(%ebp)
80104e4b:	0f 84 6a 01 00 00    	je     80104fbb <sys_unlink+0x1ab>
    end_op();
    return -1;
  }

  ilock(dp);
80104e51:	8b 75 b4             	mov    -0x4c(%ebp),%esi
80104e54:	83 ec 0c             	sub    $0xc,%esp
80104e57:	56                   	push   %esi
80104e58:	e8 13 c8 ff ff       	call   80101670 <ilock>

  // Cannot unlink "." or "..".
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
80104e5d:	58                   	pop    %eax
80104e5e:	5a                   	pop    %edx
80104e5f:	68 b8 77 10 80       	push   $0x801077b8
80104e64:	53                   	push   %ebx
80104e65:	e8 16 cd ff ff       	call   80101b80 <namecmp>
80104e6a:	83 c4 10             	add    $0x10,%esp
80104e6d:	85 c0                	test   %eax,%eax
80104e6f:	0f 84 fc 00 00 00    	je     80104f71 <sys_unlink+0x161>
80104e75:	83 ec 08             	sub    $0x8,%esp
80104e78:	68 b7 77 10 80       	push   $0x801077b7
80104e7d:	53                   	push   %ebx
80104e7e:	e8 fd cc ff ff       	call   80101b80 <namecmp>
80104e83:	83 c4 10             	add    $0x10,%esp
80104e86:	85 c0                	test   %eax,%eax
80104e88:	0f 84 e3 00 00 00    	je     80104f71 <sys_unlink+0x161>
    goto bad;

  if((ip = dirlookup(dp, name, &off)) == 0)
80104e8e:	8d 45 c4             	lea    -0x3c(%ebp),%eax
80104e91:	83 ec 04             	sub    $0x4,%esp
80104e94:	50                   	push   %eax
80104e95:	53                   	push   %ebx
80104e96:	56                   	push   %esi
80104e97:	e8 04 cd ff ff       	call   80101ba0 <dirlookup>
80104e9c:	83 c4 10             	add    $0x10,%esp
80104e9f:	85 c0                	test   %eax,%eax
80104ea1:	89 c3                	mov    %eax,%ebx
80104ea3:	0f 84 c8 00 00 00    	je     80104f71 <sys_unlink+0x161>
    goto bad;
  ilock(ip);
80104ea9:	83 ec 0c             	sub    $0xc,%esp
80104eac:	50                   	push   %eax
80104ead:	e8 be c7 ff ff       	call   80101670 <ilock>

  if(ip->nlink < 1)
80104eb2:	83 c4 10             	add    $0x10,%esp
80104eb5:	66 83 7b 56 00       	cmpw   $0x0,0x56(%ebx)
80104eba:	0f 8e 24 01 00 00    	jle    80104fe4 <sys_unlink+0x1d4>
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
80104ec0:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ec5:	8d 75 d8             	lea    -0x28(%ebp),%esi
80104ec8:	74 66                	je     80104f30 <sys_unlink+0x120>
    iunlockput(ip);
    goto bad;
  }

  memset(&de, 0, sizeof(de));
80104eca:	83 ec 04             	sub    $0x4,%esp
80104ecd:	6a 10                	push   $0x10
80104ecf:	6a 00                	push   $0x0
80104ed1:	56                   	push   %esi
80104ed2:	e8 79 f5 ff ff       	call   80104450 <memset>
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104ed7:	6a 10                	push   $0x10
80104ed9:	ff 75 c4             	pushl  -0x3c(%ebp)
80104edc:	56                   	push   %esi
80104edd:	ff 75 b4             	pushl  -0x4c(%ebp)
80104ee0:	e8 6b cb ff ff       	call   80101a50 <writei>
80104ee5:	83 c4 20             	add    $0x20,%esp
80104ee8:	83 f8 10             	cmp    $0x10,%eax
80104eeb:	0f 85 e6 00 00 00    	jne    80104fd7 <sys_unlink+0x1c7>
    panic("unlink: writei");
  if(ip->type == T_DIR){
80104ef1:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
80104ef6:	0f 84 9c 00 00 00    	je     80104f98 <sys_unlink+0x188>
    dp->nlink--;
    iupdate(dp);
  }
  iunlockput(dp);
80104efc:	83 ec 0c             	sub    $0xc,%esp
80104eff:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f02:	e8 f9 c9 ff ff       	call   80101900 <iunlockput>

  ip->nlink--;
80104f07:	66 83 6b 56 01       	subw   $0x1,0x56(%ebx)
  iupdate(ip);
80104f0c:	89 1c 24             	mov    %ebx,(%esp)
80104f0f:	e8 ac c6 ff ff       	call   801015c0 <iupdate>
  iunlockput(ip);
80104f14:	89 1c 24             	mov    %ebx,(%esp)
80104f17:	e8 e4 c9 ff ff       	call   80101900 <iunlockput>

  end_op();
80104f1c:	e8 9f dc ff ff       	call   80102bc0 <end_op>

  return 0;
80104f21:	83 c4 10             	add    $0x10,%esp
80104f24:	31 c0                	xor    %eax,%eax

bad:
  iunlockput(dp);
  end_op();
  return -1;
}
80104f26:	8d 65 f4             	lea    -0xc(%ebp),%esp
80104f29:	5b                   	pop    %ebx
80104f2a:	5e                   	pop    %esi
80104f2b:	5f                   	pop    %edi
80104f2c:	5d                   	pop    %ebp
80104f2d:	c3                   	ret    
80104f2e:	66 90                	xchg   %ax,%ax
isdirempty(struct inode *dp)
{
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
80104f30:	83 7b 58 20          	cmpl   $0x20,0x58(%ebx)
80104f34:	76 94                	jbe    80104eca <sys_unlink+0xba>
80104f36:	bf 20 00 00 00       	mov    $0x20,%edi
80104f3b:	eb 0f                	jmp    80104f4c <sys_unlink+0x13c>
80104f3d:	8d 76 00             	lea    0x0(%esi),%esi
80104f40:	83 c7 10             	add    $0x10,%edi
80104f43:	3b 7b 58             	cmp    0x58(%ebx),%edi
80104f46:	0f 83 7e ff ff ff    	jae    80104eca <sys_unlink+0xba>
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
80104f4c:	6a 10                	push   $0x10
80104f4e:	57                   	push   %edi
80104f4f:	56                   	push   %esi
80104f50:	53                   	push   %ebx
80104f51:	e8 fa c9 ff ff       	call   80101950 <readi>
80104f56:	83 c4 10             	add    $0x10,%esp
80104f59:	83 f8 10             	cmp    $0x10,%eax
80104f5c:	75 6c                	jne    80104fca <sys_unlink+0x1ba>
      panic("isdirempty: readi");
    if(de.inum != 0)
80104f5e:	66 83 7d d8 00       	cmpw   $0x0,-0x28(%ebp)
80104f63:	74 db                	je     80104f40 <sys_unlink+0x130>
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
  if(ip->type == T_DIR && !isdirempty(ip)){
    iunlockput(ip);
80104f65:	83 ec 0c             	sub    $0xc,%esp
80104f68:	53                   	push   %ebx
80104f69:	e8 92 c9 ff ff       	call   80101900 <iunlockput>
    goto bad;
80104f6e:	83 c4 10             	add    $0x10,%esp
  end_op();

  return 0;

bad:
  iunlockput(dp);
80104f71:	83 ec 0c             	sub    $0xc,%esp
80104f74:	ff 75 b4             	pushl  -0x4c(%ebp)
80104f77:	e8 84 c9 ff ff       	call   80101900 <iunlockput>
  end_op();
80104f7c:	e8 3f dc ff ff       	call   80102bc0 <end_op>
  return -1;
80104f81:	83 c4 10             	add    $0x10,%esp
}
80104f84:	8d 65 f4             	lea    -0xc(%ebp),%esp
  return 0;

bad:
  iunlockput(dp);
  end_op();
  return -1;
80104f87:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
}
80104f8c:	5b                   	pop    %ebx
80104f8d:	5e                   	pop    %esi
80104f8e:	5f                   	pop    %edi
80104f8f:	5d                   	pop    %ebp
80104f90:	c3                   	ret    
80104f91:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f98:	8b 45 b4             	mov    -0x4c(%ebp),%eax
    iupdate(dp);
80104f9b:	83 ec 0c             	sub    $0xc,%esp

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
  if(ip->type == T_DIR){
    dp->nlink--;
80104f9e:	66 83 68 56 01       	subw   $0x1,0x56(%eax)
    iupdate(dp);
80104fa3:	50                   	push   %eax
80104fa4:	e8 17 c6 ff ff       	call   801015c0 <iupdate>
80104fa9:	83 c4 10             	add    $0x10,%esp
80104fac:	e9 4b ff ff ff       	jmp    80104efc <sys_unlink+0xec>
  struct dirent de;
  char name[DIRSIZ], *path;
  uint off;

  if(argstr(0, &path) < 0)
    return -1;
80104fb1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fb6:	e9 6b ff ff ff       	jmp    80104f26 <sys_unlink+0x116>

  begin_op();
  if((dp = nameiparent(path, name)) == 0){
    end_op();
80104fbb:	e8 00 dc ff ff       	call   80102bc0 <end_op>
    return -1;
80104fc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
80104fc5:	e9 5c ff ff ff       	jmp    80104f26 <sys_unlink+0x116>
  int off;
  struct dirent de;

  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    if(readi(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
      panic("isdirempty: readi");
80104fca:	83 ec 0c             	sub    $0xc,%esp
80104fcd:	68 dc 77 10 80       	push   $0x801077dc
80104fd2:	e8 99 b3 ff ff       	call   80100370 <panic>
    goto bad;
  }

  memset(&de, 0, sizeof(de));
  if(writei(dp, (char*)&de, off, sizeof(de)) != sizeof(de))
    panic("unlink: writei");
80104fd7:	83 ec 0c             	sub    $0xc,%esp
80104fda:	68 ee 77 10 80       	push   $0x801077ee
80104fdf:	e8 8c b3 ff ff       	call   80100370 <panic>
  if((ip = dirlookup(dp, name, &off)) == 0)
    goto bad;
  ilock(ip);

  if(ip->nlink < 1)
    panic("unlink: nlink < 1");
80104fe4:	83 ec 0c             	sub    $0xc,%esp
80104fe7:	68 ca 77 10 80       	push   $0x801077ca
80104fec:	e8 7f b3 ff ff       	call   80100370 <panic>
80104ff1:	eb 0d                	jmp    80105000 <sys_open>
80104ff3:	90                   	nop
80104ff4:	90                   	nop
80104ff5:	90                   	nop
80104ff6:	90                   	nop
80104ff7:	90                   	nop
80104ff8:	90                   	nop
80104ff9:	90                   	nop
80104ffa:	90                   	nop
80104ffb:	90                   	nop
80104ffc:	90                   	nop
80104ffd:	90                   	nop
80104ffe:	90                   	nop
80104fff:	90                   	nop

80105000 <sys_open>:
  return ip;
}

int
sys_open(void)
{
80105000:	55                   	push   %ebp
80105001:	89 e5                	mov    %esp,%ebp
80105003:	57                   	push   %edi
80105004:	56                   	push   %esi
80105005:	53                   	push   %ebx
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
80105006:	8d 45 e0             	lea    -0x20(%ebp),%eax
  return ip;
}

int
sys_open(void)
{
80105009:	83 ec 24             	sub    $0x24,%esp
  char *path;
  int fd, omode;
  struct file *f;
  struct inode *ip;

  if(argstr(0, &path) < 0 || argint(1, &omode) < 0)
8010500c:	50                   	push   %eax
8010500d:	6a 00                	push   $0x0
8010500f:	e8 fc f7 ff ff       	call   80104810 <argstr>
80105014:	83 c4 10             	add    $0x10,%esp
80105017:	85 c0                	test   %eax,%eax
80105019:	0f 88 9e 00 00 00    	js     801050bd <sys_open+0xbd>
8010501f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105022:	83 ec 08             	sub    $0x8,%esp
80105025:	50                   	push   %eax
80105026:	6a 01                	push   $0x1
80105028:	e8 33 f7 ff ff       	call   80104760 <argint>
8010502d:	83 c4 10             	add    $0x10,%esp
80105030:	85 c0                	test   %eax,%eax
80105032:	0f 88 85 00 00 00    	js     801050bd <sys_open+0xbd>
    return -1;

  begin_op();
80105038:	e8 13 db ff ff       	call   80102b50 <begin_op>

  if(omode & O_CREATE){
8010503d:	f6 45 e5 02          	testb  $0x2,-0x1b(%ebp)
80105041:	0f 85 89 00 00 00    	jne    801050d0 <sys_open+0xd0>
    if(ip == 0){
      end_op();
      return -1;
    }
  } else {
    if((ip = namei(path)) == 0){
80105047:	83 ec 0c             	sub    $0xc,%esp
8010504a:	ff 75 e0             	pushl  -0x20(%ebp)
8010504d:	e8 6e ce ff ff       	call   80101ec0 <namei>
80105052:	83 c4 10             	add    $0x10,%esp
80105055:	85 c0                	test   %eax,%eax
80105057:	89 c6                	mov    %eax,%esi
80105059:	0f 84 8e 00 00 00    	je     801050ed <sys_open+0xed>
      end_op();
      return -1;
    }
    ilock(ip);
8010505f:	83 ec 0c             	sub    $0xc,%esp
80105062:	50                   	push   %eax
80105063:	e8 08 c6 ff ff       	call   80101670 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
80105068:	83 c4 10             	add    $0x10,%esp
8010506b:	66 83 7e 50 01       	cmpw   $0x1,0x50(%esi)
80105070:	0f 84 d2 00 00 00    	je     80105148 <sys_open+0x148>
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
80105076:	e8 f5 bc ff ff       	call   80100d70 <filealloc>
8010507b:	85 c0                	test   %eax,%eax
8010507d:	89 c7                	mov    %eax,%edi
8010507f:	74 2b                	je     801050ac <sys_open+0xac>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105081:	31 db                	xor    %ebx,%ebx
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105083:	e8 18 e7 ff ff       	call   801037a0 <myproc>
80105088:	90                   	nop
80105089:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105090:	8b 54 98 30          	mov    0x30(%eax,%ebx,4),%edx
80105094:	85 d2                	test   %edx,%edx
80105096:	74 68                	je     80105100 <sys_open+0x100>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105098:	83 c3 01             	add    $0x1,%ebx
8010509b:	83 fb 10             	cmp    $0x10,%ebx
8010509e:	75 f0                	jne    80105090 <sys_open+0x90>
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
801050a0:	83 ec 0c             	sub    $0xc,%esp
801050a3:	57                   	push   %edi
801050a4:	e8 87 bd ff ff       	call   80100e30 <fileclose>
801050a9:	83 c4 10             	add    $0x10,%esp
    iunlockput(ip);
801050ac:	83 ec 0c             	sub    $0xc,%esp
801050af:	56                   	push   %esi
801050b0:	e8 4b c8 ff ff       	call   80101900 <iunlockput>
    end_op();
801050b5:	e8 06 db ff ff       	call   80102bc0 <end_op>
    return -1;
801050ba:	83 c4 10             	add    $0x10,%esp
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050bd:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    if(f)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
801050c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
  return fd;
}
801050c5:	5b                   	pop    %ebx
801050c6:	5e                   	pop    %esi
801050c7:	5f                   	pop    %edi
801050c8:	5d                   	pop    %ebp
801050c9:	c3                   	ret    
801050ca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801050d0:	83 ec 0c             	sub    $0xc,%esp
801050d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
801050d6:	31 c9                	xor    %ecx,%ecx
801050d8:	6a 00                	push   $0x0
801050da:	ba 02 00 00 00       	mov    $0x2,%edx
801050df:	e8 dc f7 ff ff       	call   801048c0 <create>
    if(ip == 0){
801050e4:	83 c4 10             	add    $0x10,%esp
801050e7:	85 c0                	test   %eax,%eax
    return -1;

  begin_op();

  if(omode & O_CREATE){
    ip = create(path, T_FILE, 0, 0);
801050e9:	89 c6                	mov    %eax,%esi
    if(ip == 0){
801050eb:	75 89                	jne    80105076 <sys_open+0x76>
      end_op();
801050ed:	e8 ce da ff ff       	call   80102bc0 <end_op>
      return -1;
801050f2:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801050f7:	eb 43                	jmp    8010513c <sys_open+0x13c>
801050f9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105100:	83 ec 0c             	sub    $0xc,%esp
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105103:	89 7c 98 30          	mov    %edi,0x30(%eax,%ebx,4)
      fileclose(f);
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
80105107:	56                   	push   %esi
80105108:	e8 43 c6 ff ff       	call   80101750 <iunlock>
  end_op();
8010510d:	e8 ae da ff ff       	call   80102bc0 <end_op>

  f->type = FD_INODE;
80105112:	c7 07 02 00 00 00    	movl   $0x2,(%edi)
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105118:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
8010511b:	83 c4 10             	add    $0x10,%esp
  }
  iunlock(ip);
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
8010511e:	89 77 10             	mov    %esi,0x10(%edi)
  f->off = 0;
80105121:	c7 47 14 00 00 00 00 	movl   $0x0,0x14(%edi)
  f->readable = !(omode & O_WRONLY);
80105128:	89 d0                	mov    %edx,%eax
8010512a:	83 e0 01             	and    $0x1,%eax
8010512d:	83 f0 01             	xor    $0x1,%eax
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105130:	83 e2 03             	and    $0x3,%edx
  end_op();

  f->type = FD_INODE;
  f->ip = ip;
  f->off = 0;
  f->readable = !(omode & O_WRONLY);
80105133:	88 47 08             	mov    %al,0x8(%edi)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
80105136:	0f 95 47 09          	setne  0x9(%edi)
  return fd;
8010513a:	89 d8                	mov    %ebx,%eax
}
8010513c:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010513f:	5b                   	pop    %ebx
80105140:	5e                   	pop    %esi
80105141:	5f                   	pop    %edi
80105142:	5d                   	pop    %ebp
80105143:	c3                   	ret    
80105144:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if((ip = namei(path)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
80105148:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
8010514b:	85 c9                	test   %ecx,%ecx
8010514d:	0f 84 23 ff ff ff    	je     80105076 <sys_open+0x76>
80105153:	e9 54 ff ff ff       	jmp    801050ac <sys_open+0xac>
80105158:	90                   	nop
80105159:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105160 <sys_mkdir>:
  return fd;
}

int
sys_mkdir(void)
{
80105160:	55                   	push   %ebp
80105161:	89 e5                	mov    %esp,%ebp
80105163:	83 ec 18             	sub    $0x18,%esp
  char *path;
  struct inode *ip;

  begin_op();
80105166:	e8 e5 d9 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
8010516b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010516e:	83 ec 08             	sub    $0x8,%esp
80105171:	50                   	push   %eax
80105172:	6a 00                	push   $0x0
80105174:	e8 97 f6 ff ff       	call   80104810 <argstr>
80105179:	83 c4 10             	add    $0x10,%esp
8010517c:	85 c0                	test   %eax,%eax
8010517e:	78 30                	js     801051b0 <sys_mkdir+0x50>
80105180:	83 ec 0c             	sub    $0xc,%esp
80105183:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105186:	31 c9                	xor    %ecx,%ecx
80105188:	6a 00                	push   $0x0
8010518a:	ba 01 00 00 00       	mov    $0x1,%edx
8010518f:	e8 2c f7 ff ff       	call   801048c0 <create>
80105194:	83 c4 10             	add    $0x10,%esp
80105197:	85 c0                	test   %eax,%eax
80105199:	74 15                	je     801051b0 <sys_mkdir+0x50>
    end_op();
    return -1;
  }
  iunlockput(ip);
8010519b:	83 ec 0c             	sub    $0xc,%esp
8010519e:	50                   	push   %eax
8010519f:	e8 5c c7 ff ff       	call   80101900 <iunlockput>
  end_op();
801051a4:	e8 17 da ff ff       	call   80102bc0 <end_op>
  return 0;
801051a9:	83 c4 10             	add    $0x10,%esp
801051ac:	31 c0                	xor    %eax,%eax
}
801051ae:	c9                   	leave  
801051af:	c3                   	ret    
  char *path;
  struct inode *ip;

  begin_op();
  if(argstr(0, &path) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    end_op();
801051b0:	e8 0b da ff ff       	call   80102bc0 <end_op>
    return -1;
801051b5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
801051ba:	c9                   	leave  
801051bb:	c3                   	ret    
801051bc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801051c0 <sys_mknod>:

int
sys_mknod(void)
{
801051c0:	55                   	push   %ebp
801051c1:	89 e5                	mov    %esp,%ebp
801051c3:	83 ec 18             	sub    $0x18,%esp
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
801051c6:	e8 85 d9 ff ff       	call   80102b50 <begin_op>
  if((argstr(0, &path)) < 0 ||
801051cb:	8d 45 ec             	lea    -0x14(%ebp),%eax
801051ce:	83 ec 08             	sub    $0x8,%esp
801051d1:	50                   	push   %eax
801051d2:	6a 00                	push   $0x0
801051d4:	e8 37 f6 ff ff       	call   80104810 <argstr>
801051d9:	83 c4 10             	add    $0x10,%esp
801051dc:	85 c0                	test   %eax,%eax
801051de:	78 60                	js     80105240 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
801051e0:	8d 45 f0             	lea    -0x10(%ebp),%eax
801051e3:	83 ec 08             	sub    $0x8,%esp
801051e6:	50                   	push   %eax
801051e7:	6a 01                	push   $0x1
801051e9:	e8 72 f5 ff ff       	call   80104760 <argint>
  struct inode *ip;
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
801051ee:	83 c4 10             	add    $0x10,%esp
801051f1:	85 c0                	test   %eax,%eax
801051f3:	78 4b                	js     80105240 <sys_mknod+0x80>
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
801051f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
801051f8:	83 ec 08             	sub    $0x8,%esp
801051fb:	50                   	push   %eax
801051fc:	6a 02                	push   $0x2
801051fe:	e8 5d f5 ff ff       	call   80104760 <argint>
  char *path;
  int major, minor;

  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
80105203:	83 c4 10             	add    $0x10,%esp
80105206:	85 c0                	test   %eax,%eax
80105208:	78 36                	js     80105240 <sys_mknod+0x80>
     argint(2, &minor) < 0 ||
8010520a:	0f bf 45 f4          	movswl -0xc(%ebp),%eax
8010520e:	83 ec 0c             	sub    $0xc,%esp
80105211:	0f bf 4d f0          	movswl -0x10(%ebp),%ecx
80105215:	ba 03 00 00 00       	mov    $0x3,%edx
8010521a:	50                   	push   %eax
8010521b:	8b 45 ec             	mov    -0x14(%ebp),%eax
8010521e:	e8 9d f6 ff ff       	call   801048c0 <create>
80105223:	83 c4 10             	add    $0x10,%esp
80105226:	85 c0                	test   %eax,%eax
80105228:	74 16                	je     80105240 <sys_mknod+0x80>
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
    return -1;
  }
  iunlockput(ip);
8010522a:	83 ec 0c             	sub    $0xc,%esp
8010522d:	50                   	push   %eax
8010522e:	e8 cd c6 ff ff       	call   80101900 <iunlockput>
  end_op();
80105233:	e8 88 d9 ff ff       	call   80102bc0 <end_op>
  return 0;
80105238:	83 c4 10             	add    $0x10,%esp
8010523b:	31 c0                	xor    %eax,%eax
}
8010523d:	c9                   	leave  
8010523e:	c3                   	ret    
8010523f:	90                   	nop
  begin_op();
  if((argstr(0, &path)) < 0 ||
     argint(1, &major) < 0 ||
     argint(2, &minor) < 0 ||
     (ip = create(path, T_DEV, major, minor)) == 0){
    end_op();
80105240:	e8 7b d9 ff ff       	call   80102bc0 <end_op>
    return -1;
80105245:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  iunlockput(ip);
  end_op();
  return 0;
}
8010524a:	c9                   	leave  
8010524b:	c3                   	ret    
8010524c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105250 <sys_chdir>:

int
sys_chdir(void)
{
80105250:	55                   	push   %ebp
80105251:	89 e5                	mov    %esp,%ebp
80105253:	56                   	push   %esi
80105254:	53                   	push   %ebx
80105255:	83 ec 10             	sub    $0x10,%esp
  char *path;
  struct inode *ip;
  struct proc *curproc = myproc();
80105258:	e8 43 e5 ff ff       	call   801037a0 <myproc>
8010525d:	89 c6                	mov    %eax,%esi
  
  begin_op();
8010525f:	e8 ec d8 ff ff       	call   80102b50 <begin_op>
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
80105264:	8d 45 f4             	lea    -0xc(%ebp),%eax
80105267:	83 ec 08             	sub    $0x8,%esp
8010526a:	50                   	push   %eax
8010526b:	6a 00                	push   $0x0
8010526d:	e8 9e f5 ff ff       	call   80104810 <argstr>
80105272:	83 c4 10             	add    $0x10,%esp
80105275:	85 c0                	test   %eax,%eax
80105277:	78 77                	js     801052f0 <sys_chdir+0xa0>
80105279:	83 ec 0c             	sub    $0xc,%esp
8010527c:	ff 75 f4             	pushl  -0xc(%ebp)
8010527f:	e8 3c cc ff ff       	call   80101ec0 <namei>
80105284:	83 c4 10             	add    $0x10,%esp
80105287:	85 c0                	test   %eax,%eax
80105289:	89 c3                	mov    %eax,%ebx
8010528b:	74 63                	je     801052f0 <sys_chdir+0xa0>
    end_op();
    return -1;
  }
  ilock(ip);
8010528d:	83 ec 0c             	sub    $0xc,%esp
80105290:	50                   	push   %eax
80105291:	e8 da c3 ff ff       	call   80101670 <ilock>
  if(ip->type != T_DIR){
80105296:	83 c4 10             	add    $0x10,%esp
80105299:	66 83 7b 50 01       	cmpw   $0x1,0x50(%ebx)
8010529e:	75 30                	jne    801052d0 <sys_chdir+0x80>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
801052a0:	83 ec 0c             	sub    $0xc,%esp
801052a3:	53                   	push   %ebx
801052a4:	e8 a7 c4 ff ff       	call   80101750 <iunlock>
  iput(curproc->cwd);
801052a9:	58                   	pop    %eax
801052aa:	ff 76 70             	pushl  0x70(%esi)
801052ad:	e8 ee c4 ff ff       	call   801017a0 <iput>
  end_op();
801052b2:	e8 09 d9 ff ff       	call   80102bc0 <end_op>
  curproc->cwd = ip;
801052b7:	89 5e 70             	mov    %ebx,0x70(%esi)
  return 0;
801052ba:	83 c4 10             	add    $0x10,%esp
801052bd:	31 c0                	xor    %eax,%eax
}
801052bf:	8d 65 f8             	lea    -0x8(%ebp),%esp
801052c2:	5b                   	pop    %ebx
801052c3:	5e                   	pop    %esi
801052c4:	5d                   	pop    %ebp
801052c5:	c3                   	ret    
801052c6:	8d 76 00             	lea    0x0(%esi),%esi
801052c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    end_op();
    return -1;
  }
  ilock(ip);
  if(ip->type != T_DIR){
    iunlockput(ip);
801052d0:	83 ec 0c             	sub    $0xc,%esp
801052d3:	53                   	push   %ebx
801052d4:	e8 27 c6 ff ff       	call   80101900 <iunlockput>
    end_op();
801052d9:	e8 e2 d8 ff ff       	call   80102bc0 <end_op>
    return -1;
801052de:	83 c4 10             	add    $0x10,%esp
801052e1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052e6:	eb d7                	jmp    801052bf <sys_chdir+0x6f>
801052e8:	90                   	nop
801052e9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
  struct inode *ip;
  struct proc *curproc = myproc();
  
  begin_op();
  if(argstr(0, &path) < 0 || (ip = namei(path)) == 0){
    end_op();
801052f0:	e8 cb d8 ff ff       	call   80102bc0 <end_op>
    return -1;
801052f5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
801052fa:	eb c3                	jmp    801052bf <sys_chdir+0x6f>
801052fc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105300 <sys_exec>:
  return 0;
}

int
sys_exec(void)
{
80105300:	55                   	push   %ebp
80105301:	89 e5                	mov    %esp,%ebp
80105303:	57                   	push   %edi
80105304:	56                   	push   %esi
80105305:	53                   	push   %ebx
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105306:	8d 85 5c ff ff ff    	lea    -0xa4(%ebp),%eax
  return 0;
}

int
sys_exec(void)
{
8010530c:	81 ec a4 00 00 00    	sub    $0xa4,%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
80105312:	50                   	push   %eax
80105313:	6a 00                	push   $0x0
80105315:	e8 f6 f4 ff ff       	call   80104810 <argstr>
8010531a:	83 c4 10             	add    $0x10,%esp
8010531d:	85 c0                	test   %eax,%eax
8010531f:	78 7f                	js     801053a0 <sys_exec+0xa0>
80105321:	8d 85 60 ff ff ff    	lea    -0xa0(%ebp),%eax
80105327:	83 ec 08             	sub    $0x8,%esp
8010532a:	50                   	push   %eax
8010532b:	6a 01                	push   $0x1
8010532d:	e8 2e f4 ff ff       	call   80104760 <argint>
80105332:	83 c4 10             	add    $0x10,%esp
80105335:	85 c0                	test   %eax,%eax
80105337:	78 67                	js     801053a0 <sys_exec+0xa0>
    return -1;
  }
  memset(argv, 0, sizeof(argv));
80105339:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
8010533f:	83 ec 04             	sub    $0x4,%esp
80105342:	8d b5 68 ff ff ff    	lea    -0x98(%ebp),%esi
80105348:	68 80 00 00 00       	push   $0x80
8010534d:	6a 00                	push   $0x0
8010534f:	8d bd 64 ff ff ff    	lea    -0x9c(%ebp),%edi
80105355:	50                   	push   %eax
80105356:	31 db                	xor    %ebx,%ebx
80105358:	e8 f3 f0 ff ff       	call   80104450 <memset>
8010535d:	83 c4 10             	add    $0x10,%esp
  for(i=0;; i++){
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
80105360:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
80105366:	83 ec 08             	sub    $0x8,%esp
80105369:	57                   	push   %edi
8010536a:	8d 04 98             	lea    (%eax,%ebx,4),%eax
8010536d:	50                   	push   %eax
8010536e:	e8 4d f3 ff ff       	call   801046c0 <fetchint>
80105373:	83 c4 10             	add    $0x10,%esp
80105376:	85 c0                	test   %eax,%eax
80105378:	78 26                	js     801053a0 <sys_exec+0xa0>
      return -1;
    if(uarg == 0){
8010537a:	8b 85 64 ff ff ff    	mov    -0x9c(%ebp),%eax
80105380:	85 c0                	test   %eax,%eax
80105382:	74 2c                	je     801053b0 <sys_exec+0xb0>
      argv[i] = 0;
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
80105384:	83 ec 08             	sub    $0x8,%esp
80105387:	56                   	push   %esi
80105388:	50                   	push   %eax
80105389:	e8 72 f3 ff ff       	call   80104700 <fetchstr>
8010538e:	83 c4 10             	add    $0x10,%esp
80105391:	85 c0                	test   %eax,%eax
80105393:	78 0b                	js     801053a0 <sys_exec+0xa0>

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
  }
  memset(argv, 0, sizeof(argv));
  for(i=0;; i++){
80105395:	83 c3 01             	add    $0x1,%ebx
80105398:	83 c6 04             	add    $0x4,%esi
    if(i >= NELEM(argv))
8010539b:	83 fb 20             	cmp    $0x20,%ebx
8010539e:	75 c0                	jne    80105360 <sys_exec+0x60>
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053a0:	8d 65 f4             	lea    -0xc(%ebp),%esp
  char *path, *argv[MAXARG];
  int i;
  uint uargv, uarg;

  if(argstr(0, &path) < 0 || argint(1, (int*)&uargv) < 0){
    return -1;
801053a3:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
}
801053a8:	5b                   	pop    %ebx
801053a9:	5e                   	pop    %esi
801053aa:	5f                   	pop    %edi
801053ab:	5d                   	pop    %ebp
801053ac:	c3                   	ret    
801053ad:	8d 76 00             	lea    0x0(%esi),%esi
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801053b0:	8d 85 68 ff ff ff    	lea    -0x98(%ebp),%eax
801053b6:	83 ec 08             	sub    $0x8,%esp
    if(i >= NELEM(argv))
      return -1;
    if(fetchint(uargv+4*i, (int*)&uarg) < 0)
      return -1;
    if(uarg == 0){
      argv[i] = 0;
801053b9:	c7 84 9d 68 ff ff ff 	movl   $0x0,-0x98(%ebp,%ebx,4)
801053c0:	00 00 00 00 
      break;
    }
    if(fetchstr(uarg, &argv[i]) < 0)
      return -1;
  }
  return exec(path, argv);
801053c4:	50                   	push   %eax
801053c5:	ff b5 5c ff ff ff    	pushl  -0xa4(%ebp)
801053cb:	e8 20 b6 ff ff       	call   801009f0 <exec>
801053d0:	83 c4 10             	add    $0x10,%esp
}
801053d3:	8d 65 f4             	lea    -0xc(%ebp),%esp
801053d6:	5b                   	pop    %ebx
801053d7:	5e                   	pop    %esi
801053d8:	5f                   	pop    %edi
801053d9:	5d                   	pop    %ebp
801053da:	c3                   	ret    
801053db:	90                   	nop
801053dc:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

801053e0 <sys_pipe>:

int
sys_pipe(void)
{
801053e0:	55                   	push   %ebp
801053e1:	89 e5                	mov    %esp,%ebp
801053e3:	57                   	push   %edi
801053e4:	56                   	push   %esi
801053e5:	53                   	push   %ebx
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053e6:	8d 45 dc             	lea    -0x24(%ebp),%eax
  return exec(path, argv);
}

int
sys_pipe(void)
{
801053e9:	83 ec 20             	sub    $0x20,%esp
  int *fd;
  struct file *rf, *wf;
  int fd0, fd1;

  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
801053ec:	6a 08                	push   $0x8
801053ee:	50                   	push   %eax
801053ef:	6a 00                	push   $0x0
801053f1:	e8 ba f3 ff ff       	call   801047b0 <argptr>
801053f6:	83 c4 10             	add    $0x10,%esp
801053f9:	85 c0                	test   %eax,%eax
801053fb:	78 4a                	js     80105447 <sys_pipe+0x67>
    return -1;
  if(pipealloc(&rf, &wf) < 0)
801053fd:	8d 45 e4             	lea    -0x1c(%ebp),%eax
80105400:	83 ec 08             	sub    $0x8,%esp
80105403:	50                   	push   %eax
80105404:	8d 45 e0             	lea    -0x20(%ebp),%eax
80105407:	50                   	push   %eax
80105408:	e8 e3 dd ff ff       	call   801031f0 <pipealloc>
8010540d:	83 c4 10             	add    $0x10,%esp
80105410:	85 c0                	test   %eax,%eax
80105412:	78 33                	js     80105447 <sys_pipe+0x67>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105414:	31 db                	xor    %ebx,%ebx
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
80105416:	8b 7d e0             	mov    -0x20(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105419:	e8 82 e3 ff ff       	call   801037a0 <myproc>
8010541e:	66 90                	xchg   %ax,%ax

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
80105420:	8b 74 98 30          	mov    0x30(%eax,%ebx,4),%esi
80105424:	85 f6                	test   %esi,%esi
80105426:	74 30                	je     80105458 <sys_pipe+0x78>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105428:	83 c3 01             	add    $0x1,%ebx
8010542b:	83 fb 10             	cmp    $0x10,%ebx
8010542e:	75 f0                	jne    80105420 <sys_pipe+0x40>
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
80105430:	83 ec 0c             	sub    $0xc,%esp
80105433:	ff 75 e0             	pushl  -0x20(%ebp)
80105436:	e8 f5 b9 ff ff       	call   80100e30 <fileclose>
    fileclose(wf);
8010543b:	58                   	pop    %eax
8010543c:	ff 75 e4             	pushl  -0x1c(%ebp)
8010543f:	e8 ec b9 ff ff       	call   80100e30 <fileclose>
    return -1;
80105444:	83 c4 10             	add    $0x10,%esp
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
80105447:	8d 65 f4             	lea    -0xc(%ebp),%esp
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
8010544a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
}
8010544f:	5b                   	pop    %ebx
80105450:	5e                   	pop    %esi
80105451:	5f                   	pop    %edi
80105452:	5d                   	pop    %ebp
80105453:	c3                   	ret    
80105454:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105458:	8d 73 0c             	lea    0xc(%ebx),%esi
8010545b:	89 3c b0             	mov    %edi,(%eax,%esi,4)
  if(argptr(0, (void*)&fd, 2*sizeof(fd[0])) < 0)
    return -1;
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
8010545e:	8b 7d e4             	mov    -0x1c(%ebp),%edi
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();
80105461:	e8 3a e3 ff ff       	call   801037a0 <myproc>

  for(fd = 0; fd < NOFILE; fd++){
80105466:	31 d2                	xor    %edx,%edx
80105468:	90                   	nop
80105469:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    if(curproc->ofile[fd] == 0){
80105470:	8b 4c 90 30          	mov    0x30(%eax,%edx,4),%ecx
80105474:	85 c9                	test   %ecx,%ecx
80105476:	74 18                	je     80105490 <sys_pipe+0xb0>
fdalloc(struct file *f)
{
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
80105478:	83 c2 01             	add    $0x1,%edx
8010547b:	83 fa 10             	cmp    $0x10,%edx
8010547e:	75 f0                	jne    80105470 <sys_pipe+0x90>
  if(pipealloc(&rf, &wf) < 0)
    return -1;
  fd0 = -1;
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    if(fd0 >= 0)
      myproc()->ofile[fd0] = 0;
80105480:	e8 1b e3 ff ff       	call   801037a0 <myproc>
80105485:	c7 04 b0 00 00 00 00 	movl   $0x0,(%eax,%esi,4)
8010548c:	eb a2                	jmp    80105430 <sys_pipe+0x50>
8010548e:	66 90                	xchg   %ax,%ax
  int fd;
  struct proc *curproc = myproc();

  for(fd = 0; fd < NOFILE; fd++){
    if(curproc->ofile[fd] == 0){
      curproc->ofile[fd] = f;
80105490:	89 7c 90 30          	mov    %edi,0x30(%eax,%edx,4)
      myproc()->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
80105494:	8b 45 dc             	mov    -0x24(%ebp),%eax
80105497:	89 18                	mov    %ebx,(%eax)
  fd[1] = fd1;
80105499:	8b 45 dc             	mov    -0x24(%ebp),%eax
8010549c:	89 50 04             	mov    %edx,0x4(%eax)
  return 0;
}
8010549f:	8d 65 f4             	lea    -0xc(%ebp),%esp
    fileclose(wf);
    return -1;
  }
  fd[0] = fd0;
  fd[1] = fd1;
  return 0;
801054a2:	31 c0                	xor    %eax,%eax
}
801054a4:	5b                   	pop    %ebx
801054a5:	5e                   	pop    %esi
801054a6:	5f                   	pop    %edi
801054a7:	5d                   	pop    %ebp
801054a8:	c3                   	ret    
801054a9:	66 90                	xchg   %ax,%ax
801054ab:	66 90                	xchg   %ax,%ax
801054ad:	66 90                	xchg   %ax,%ax
801054af:	90                   	nop

801054b0 <sysCallNum>:
const char *callNames[23] = { "fork", "exit", "wait", "pipe", "read", "kill", "exec", "fstat", "chdir", "dup", "getpid", "sbrk"
                              , "sleep", "uptime", "open", "write", "mknod", "unlink", "link", "mkdir", "close", "trace" , "\0"
                            }; //Map of System Call to Index(-1) to return call name -- Aaron

int
sysCallNum(void) { //Return System call number --Cullen
801054b0:	55                   	push   %ebp
801054b1:	89 e5                	mov    %esp,%ebp
801054b3:	83 ec 08             	sub    $0x8,%esp
  int num;
  struct proc *curproc = myproc();
801054b6:	e8 e5 e2 ff ff       	call   801037a0 <myproc>
  num = curproc->tf->eax;
801054bb:	8b 40 20             	mov    0x20(%eax),%eax
  return num;
801054be:	8b 40 1c             	mov    0x1c(%eax),%eax
}
801054c1:	c9                   	leave  
801054c2:	c3                   	ret    
801054c3:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
801054c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801054d0 <trace_helper>:

void
trace_helper(void) { //Print out system call --Cullen
801054d0:	55                   	push   %ebp
801054d1:	89 e5                	mov    %esp,%ebp
801054d3:	83 ec 08             	sub    $0x8,%esp
  if (myproc()->printSys == 0) { //Check if Trace is off
801054d6:	e8 c5 e2 ff ff       	call   801037a0 <myproc>
801054db:	8b 40 04             	mov    0x4(%eax),%eax
801054de:	85 c0                	test   %eax,%eax
801054e0:	75 06                	jne    801054e8 <trace_helper+0x18>
    cprintf("[%s] ", myproc()->name); //Process Name
    cprintf("syscall(%d=", sysCallNum());
    cprintf("%s)\n", callNames[sysCallNum() - 1]); //Access Map from # to Call Name

  }
}
801054e2:	c9                   	leave  
801054e3:	c3                   	ret    
801054e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
trace_helper(void) { //Print out system call --Cullen
  if (myproc()->printSys == 0) { //Check if Trace is off
    //do nothing
  }
  else { //Trace is on
    cprintf("pid: %d ", myproc()->pid); //Process ID
801054e8:	e8 b3 e2 ff ff       	call   801037a0 <myproc>
801054ed:	83 ec 08             	sub    $0x8,%esp
801054f0:	ff 70 18             	pushl  0x18(%eax)
801054f3:	68 fd 77 10 80       	push   $0x801077fd
801054f8:	e8 63 b1 ff ff       	call   80100660 <cprintf>
    cprintf("[%s] ", myproc()->name); //Process Name
801054fd:	e8 9e e2 ff ff       	call   801037a0 <myproc>
80105502:	5a                   	pop    %edx
80105503:	59                   	pop    %ecx
80105504:	83 c0 74             	add    $0x74,%eax
80105507:	50                   	push   %eax
80105508:	68 06 78 10 80       	push   $0x80107806
8010550d:	e8 4e b1 ff ff       	call   80100660 <cprintf>
                            }; //Map of System Call to Index(-1) to return call name -- Aaron

int
sysCallNum(void) { //Return System call number --Cullen
  int num;
  struct proc *curproc = myproc();
80105512:	e8 89 e2 ff ff       	call   801037a0 <myproc>
  num = curproc->tf->eax;
80105517:	8b 40 20             	mov    0x20(%eax),%eax
    //do nothing
  }
  else { //Trace is on
    cprintf("pid: %d ", myproc()->pid); //Process ID
    cprintf("[%s] ", myproc()->name); //Process Name
    cprintf("syscall(%d=", sysCallNum());
8010551a:	5a                   	pop    %edx
8010551b:	59                   	pop    %ecx
8010551c:	ff 70 1c             	pushl  0x1c(%eax)
8010551f:	68 0c 78 10 80       	push   $0x8010780c
80105524:	e8 37 b1 ff ff       	call   80100660 <cprintf>
                            }; //Map of System Call to Index(-1) to return call name -- Aaron

int
sysCallNum(void) { //Return System call number --Cullen
  int num;
  struct proc *curproc = myproc();
80105529:	e8 72 e2 ff ff       	call   801037a0 <myproc>
  num = curproc->tf->eax;
8010552e:	8b 40 20             	mov    0x20(%eax),%eax
  }
  else { //Trace is on
    cprintf("pid: %d ", myproc()->pid); //Process ID
    cprintf("[%s] ", myproc()->name); //Process Name
    cprintf("syscall(%d=", sysCallNum());
    cprintf("%s)\n", callNames[sysCallNum() - 1]); //Access Map from # to Call Name
80105531:	5a                   	pop    %edx
80105532:	59                   	pop    %ecx
80105533:	8b 40 1c             	mov    0x1c(%eax),%eax
80105536:	ff 34 85 1c a0 10 80 	pushl  -0x7fef5fe4(,%eax,4)
8010553d:	68 18 78 10 80       	push   $0x80107818
80105542:	e8 19 b1 ff ff       	call   80100660 <cprintf>
80105547:	83 c4 10             	add    $0x10,%esp

  }
}
8010554a:	c9                   	leave  
8010554b:	c3                   	ret    
8010554c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105550 <sys_fork>:

int
sys_fork(void)
{
80105550:	55                   	push   %ebp
80105551:	89 e5                	mov    %esp,%ebp
80105553:	83 ec 08             	sub    $0x8,%esp
  trace_helper();
80105556:	e8 75 ff ff ff       	call   801054d0 <trace_helper>

  return fork();
}
8010555b:	c9                   	leave  
int
sys_fork(void)
{
  trace_helper();

  return fork();
8010555c:	e9 df e3 ff ff       	jmp    80103940 <fork>
80105561:	eb 0d                	jmp    80105570 <sys_exit>
80105563:	90                   	nop
80105564:	90                   	nop
80105565:	90                   	nop
80105566:	90                   	nop
80105567:	90                   	nop
80105568:	90                   	nop
80105569:	90                   	nop
8010556a:	90                   	nop
8010556b:	90                   	nop
8010556c:	90                   	nop
8010556d:	90                   	nop
8010556e:	90                   	nop
8010556f:	90                   	nop

80105570 <sys_exit>:
}

int
sys_exit(void)
{
80105570:	55                   	push   %ebp
80105571:	89 e5                	mov    %esp,%ebp
80105573:	83 ec 08             	sub    $0x8,%esp
  trace_helper();
80105576:	e8 55 ff ff ff       	call   801054d0 <trace_helper>

  exit();
8010557b:	e8 50 e6 ff ff       	call   80103bd0 <exit>
  return 0;  // not reached
}
80105580:	31 c0                	xor    %eax,%eax
80105582:	c9                   	leave  
80105583:	c3                   	ret    
80105584:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
8010558a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80105590 <sys_wait>:

int
sys_wait(void)
{
80105590:	55                   	push   %ebp
80105591:	89 e5                	mov    %esp,%ebp
80105593:	83 ec 08             	sub    $0x8,%esp
  trace_helper();
80105596:	e8 35 ff ff ff       	call   801054d0 <trace_helper>

  return wait();
}
8010559b:	c9                   	leave  
int
sys_wait(void)
{
  trace_helper();

  return wait();
8010559c:	e9 6f e8 ff ff       	jmp    80103e10 <wait>
801055a1:	eb 0d                	jmp    801055b0 <sys_kill>
801055a3:	90                   	nop
801055a4:	90                   	nop
801055a5:	90                   	nop
801055a6:	90                   	nop
801055a7:	90                   	nop
801055a8:	90                   	nop
801055a9:	90                   	nop
801055aa:	90                   	nop
801055ab:	90                   	nop
801055ac:	90                   	nop
801055ad:	90                   	nop
801055ae:	90                   	nop
801055af:	90                   	nop

801055b0 <sys_kill>:
}

int
sys_kill(void)
{
801055b0:	55                   	push   %ebp
801055b1:	89 e5                	mov    %esp,%ebp
801055b3:	83 ec 18             	sub    $0x18,%esp
  trace_helper();
801055b6:	e8 15 ff ff ff       	call   801054d0 <trace_helper>

  int pid;

  if (argint(0, &pid) < 0)
801055bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
801055be:	83 ec 08             	sub    $0x8,%esp
801055c1:	50                   	push   %eax
801055c2:	6a 00                	push   $0x0
801055c4:	e8 97 f1 ff ff       	call   80104760 <argint>
801055c9:	83 c4 10             	add    $0x10,%esp
801055cc:	85 c0                	test   %eax,%eax
801055ce:	78 10                	js     801055e0 <sys_kill+0x30>
    return -1;
  return kill(pid);
801055d0:	83 ec 0c             	sub    $0xc,%esp
801055d3:	ff 75 f4             	pushl  -0xc(%ebp)
801055d6:	e8 95 e9 ff ff       	call   80103f70 <kill>
801055db:	83 c4 10             	add    $0x10,%esp
}
801055de:	c9                   	leave  
801055df:	c3                   	ret    
  trace_helper();

  int pid;

  if (argint(0, &pid) < 0)
    return -1;
801055e0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  return kill(pid);
}
801055e5:	c9                   	leave  
801055e6:	c3                   	ret    
801055e7:	89 f6                	mov    %esi,%esi
801055e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801055f0 <sys_getpid>:

int
sys_getpid(void)
{
801055f0:	55                   	push   %ebp
801055f1:	89 e5                	mov    %esp,%ebp
801055f3:	83 ec 08             	sub    $0x8,%esp
  trace_helper();
801055f6:	e8 d5 fe ff ff       	call   801054d0 <trace_helper>

  return myproc()->pid;
801055fb:	e8 a0 e1 ff ff       	call   801037a0 <myproc>
80105600:	8b 40 18             	mov    0x18(%eax),%eax
}
80105603:	c9                   	leave  
80105604:	c3                   	ret    
80105605:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
80105609:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105610 <sys_sbrk>:

int
sys_sbrk(void)
{
80105610:	55                   	push   %ebp
80105611:	89 e5                	mov    %esp,%ebp
80105613:	53                   	push   %ebx
80105614:	83 ec 14             	sub    $0x14,%esp
  trace_helper();
80105617:	e8 b4 fe ff ff       	call   801054d0 <trace_helper>

  int addr;
  int n;

  if (argint(0, &n) < 0)
8010561c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010561f:	83 ec 08             	sub    $0x8,%esp
80105622:	50                   	push   %eax
80105623:	6a 00                	push   $0x0
80105625:	e8 36 f1 ff ff       	call   80104760 <argint>
8010562a:	83 c4 10             	add    $0x10,%esp
8010562d:	85 c0                	test   %eax,%eax
8010562f:	78 27                	js     80105658 <sys_sbrk+0x48>
    return -1;
  addr = myproc()->sz;
80105631:	e8 6a e1 ff ff       	call   801037a0 <myproc>
  if (growproc(n) < 0)
80105636:	83 ec 0c             	sub    $0xc,%esp
  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
  addr = myproc()->sz;
80105639:	8b 18                	mov    (%eax),%ebx
  if (growproc(n) < 0)
8010563b:	ff 75 f4             	pushl  -0xc(%ebp)
8010563e:	e8 7d e2 ff ff       	call   801038c0 <growproc>
80105643:	83 c4 10             	add    $0x10,%esp
80105646:	85 c0                	test   %eax,%eax
80105648:	78 0e                	js     80105658 <sys_sbrk+0x48>
    return -1;
  return addr;
8010564a:	89 d8                	mov    %ebx,%eax
}
8010564c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
8010564f:	c9                   	leave  
80105650:	c3                   	ret    
80105651:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

  int addr;
  int n;

  if (argint(0, &n) < 0)
    return -1;
80105658:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010565d:	eb ed                	jmp    8010564c <sys_sbrk+0x3c>
8010565f:	90                   	nop

80105660 <sys_sleep>:
  return addr;
}

int
sys_sleep(void)
{
80105660:	55                   	push   %ebp
80105661:	89 e5                	mov    %esp,%ebp
80105663:	53                   	push   %ebx
80105664:	83 ec 14             	sub    $0x14,%esp
  trace_helper();
80105667:	e8 64 fe ff ff       	call   801054d0 <trace_helper>

  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
8010566c:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010566f:	83 ec 08             	sub    $0x8,%esp
80105672:	50                   	push   %eax
80105673:	6a 00                	push   $0x0
80105675:	e8 e6 f0 ff ff       	call   80104760 <argint>
8010567a:	83 c4 10             	add    $0x10,%esp
8010567d:	85 c0                	test   %eax,%eax
8010567f:	0f 88 82 00 00 00    	js     80105707 <sys_sleep+0xa7>
    return -1;
  acquire(&tickslock);
80105685:	83 ec 0c             	sub    $0xc,%esp
80105688:	68 c0 4e 11 80       	push   $0x80114ec0
8010568d:	e8 be ec ff ff       	call   80104350 <acquire>
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
80105692:	8b 55 f4             	mov    -0xc(%ebp),%edx
80105695:	83 c4 10             	add    $0x10,%esp
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
80105698:	8b 1d 00 57 11 80    	mov    0x80115700,%ebx
  while (ticks - ticks0 < n) {
8010569e:	85 d2                	test   %edx,%edx
801056a0:	75 27                	jne    801056c9 <sys_sleep+0x69>
801056a2:	eb 4c                	jmp    801056f0 <sys_sleep+0x90>
801056a4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    if (myproc()->killed) {
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
801056a8:	83 ec 08             	sub    $0x8,%esp
801056ab:	68 c0 4e 11 80       	push   $0x80114ec0
801056b0:	68 00 57 11 80       	push   $0x80115700
801056b5:	e8 96 e6 ff ff       	call   80103d50 <sleep>

  if (argint(0, &n) < 0)
    return -1;
  acquire(&tickslock);
  ticks0 = ticks;
  while (ticks - ticks0 < n) {
801056ba:	a1 00 57 11 80       	mov    0x80115700,%eax
801056bf:	83 c4 10             	add    $0x10,%esp
801056c2:	29 d8                	sub    %ebx,%eax
801056c4:	3b 45 f4             	cmp    -0xc(%ebp),%eax
801056c7:	73 27                	jae    801056f0 <sys_sleep+0x90>
    if (myproc()->killed) {
801056c9:	e8 d2 e0 ff ff       	call   801037a0 <myproc>
801056ce:	8b 40 2c             	mov    0x2c(%eax),%eax
801056d1:	85 c0                	test   %eax,%eax
801056d3:	74 d3                	je     801056a8 <sys_sleep+0x48>
      release(&tickslock);
801056d5:	83 ec 0c             	sub    $0xc,%esp
801056d8:	68 c0 4e 11 80       	push   $0x80114ec0
801056dd:	e8 1e ed ff ff       	call   80104400 <release>
      return -1;
801056e2:	83 c4 10             	add    $0x10,%esp
801056e5:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}
801056ea:	8b 5d fc             	mov    -0x4(%ebp),%ebx
801056ed:	c9                   	leave  
801056ee:	c3                   	ret    
801056ef:	90                   	nop
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
801056f0:	83 ec 0c             	sub    $0xc,%esp
801056f3:	68 c0 4e 11 80       	push   $0x80114ec0
801056f8:	e8 03 ed ff ff       	call   80104400 <release>
  return 0;
801056fd:	83 c4 10             	add    $0x10,%esp
80105700:	31 c0                	xor    %eax,%eax
}
80105702:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105705:	c9                   	leave  
80105706:	c3                   	ret    

  int n;
  uint ticks0;

  if (argint(0, &n) < 0)
    return -1;
80105707:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
8010570c:	eb dc                	jmp    801056ea <sys_sleep+0x8a>
8010570e:	66 90                	xchg   %ax,%ax

80105710 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
int
sys_uptime(void)
{
80105710:	55                   	push   %ebp
80105711:	89 e5                	mov    %esp,%ebp
80105713:	53                   	push   %ebx
80105714:	83 ec 04             	sub    $0x4,%esp
  trace_helper();
80105717:	e8 b4 fd ff ff       	call   801054d0 <trace_helper>

  uint xticks;

  acquire(&tickslock);
8010571c:	83 ec 0c             	sub    $0xc,%esp
8010571f:	68 c0 4e 11 80       	push   $0x80114ec0
80105724:	e8 27 ec ff ff       	call   80104350 <acquire>
  xticks = ticks;
80105729:	8b 1d 00 57 11 80    	mov    0x80115700,%ebx
  release(&tickslock);
8010572f:	c7 04 24 c0 4e 11 80 	movl   $0x80114ec0,(%esp)
80105736:	e8 c5 ec ff ff       	call   80104400 <release>
  return xticks;
}
8010573b:	89 d8                	mov    %ebx,%eax
8010573d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
80105740:	c9                   	leave  
80105741:	c3                   	ret    
80105742:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105749:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105750 <sys_trace>:

int
sys_trace(void) // --Aaron
{
80105750:	55                   	push   %ebp
80105751:	89 e5                	mov    %esp,%ebp
80105753:	83 ec 18             	sub    $0x18,%esp
  trace_helper();
80105756:	e8 75 fd ff ff       	call   801054d0 <trace_helper>

  int n;
  //check to see if n is pointing to mem that does not exist
  if (argint(0, &n) < 0) {
8010575b:	8d 45 f4             	lea    -0xc(%ebp),%eax
8010575e:	83 ec 08             	sub    $0x8,%esp
80105761:	50                   	push   %eax
80105762:	6a 00                	push   $0x0
80105764:	e8 f7 ef ff ff       	call   80104760 <argint>
80105769:	83 c4 10             	add    $0x10,%esp
8010576c:	85 c0                	test   %eax,%eax
8010576e:	78 30                	js     801057a0 <sys_trace+0x50>
    return -1;
  }


  if (n == 0) { //Turn trace off
80105770:	8b 45 f4             	mov    -0xc(%ebp),%eax
80105773:	85 c0                	test   %eax,%eax
80105775:	74 19                	je     80105790 <sys_trace+0x40>
    myproc()->printSys = 0;
  }
  else { //Turn trace on 
    myproc()->printSys = 1;
80105777:	e8 24 e0 ff ff       	call   801037a0 <myproc>
8010577c:	c7 40 04 01 00 00 00 	movl   $0x1,0x4(%eax)
  }
  return myproc()->numCalls; //return number of system calls
80105783:	e8 18 e0 ff ff       	call   801037a0 <myproc>
80105788:	8b 40 08             	mov    0x8(%eax),%eax
}
8010578b:	c9                   	leave  
8010578c:	c3                   	ret    
8010578d:	8d 76 00             	lea    0x0(%esi),%esi
    return -1;
  }


  if (n == 0) { //Turn trace off
    myproc()->printSys = 0;
80105790:	e8 0b e0 ff ff       	call   801037a0 <myproc>
80105795:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
8010579c:	eb e5                	jmp    80105783 <sys_trace+0x33>
8010579e:	66 90                	xchg   %ax,%ax
  trace_helper();

  int n;
  //check to see if n is pointing to mem that does not exist
  if (argint(0, &n) < 0) {
    return -1;
801057a0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  else { //Turn trace on 
    myproc()->printSys = 1;
  }
  return myproc()->numCalls; //return number of system calls
}
801057a5:	c9                   	leave  
801057a6:	c3                   	ret    

801057a7 <alltraps>:

  # vectors.S sends all traps here.
.globl alltraps
alltraps:
  # Build trap frame.
  pushl %ds
801057a7:	1e                   	push   %ds
  pushl %es
801057a8:	06                   	push   %es
  pushl %fs
801057a9:	0f a0                	push   %fs
  pushl %gs
801057ab:	0f a8                	push   %gs
  pushal
801057ad:	60                   	pusha  
  
  # Set up data segments.
  movw $(SEG_KDATA<<3), %ax
801057ae:	66 b8 10 00          	mov    $0x10,%ax
  movw %ax, %ds
801057b2:	8e d8                	mov    %eax,%ds
  movw %ax, %es
801057b4:	8e c0                	mov    %eax,%es

  # Call trap(tf), where tf=%esp
  pushl %esp
801057b6:	54                   	push   %esp
  call trap
801057b7:	e8 e4 00 00 00       	call   801058a0 <trap>
  addl $4, %esp
801057bc:	83 c4 04             	add    $0x4,%esp

801057bf <trapret>:

  # Return falls through to trapret...
.globl trapret
trapret:
  popal
801057bf:	61                   	popa   
  popl %gs
801057c0:	0f a9                	pop    %gs
  popl %fs
801057c2:	0f a1                	pop    %fs
  popl %es
801057c4:	07                   	pop    %es
  popl %ds
801057c5:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
801057c6:	83 c4 08             	add    $0x8,%esp
  iret
801057c9:	cf                   	iret   
801057ca:	66 90                	xchg   %ax,%ax
801057cc:	66 90                	xchg   %ax,%ax
801057ce:	66 90                	xchg   %ax,%ax

801057d0 <tvinit>:
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
801057d0:	31 c0                	xor    %eax,%eax
801057d2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
801057d8:	8b 14 85 7c a0 10 80 	mov    -0x7fef5f84(,%eax,4),%edx
801057df:	b9 08 00 00 00       	mov    $0x8,%ecx
801057e4:	c6 04 c5 04 4f 11 80 	movb   $0x0,-0x7feeb0fc(,%eax,8)
801057eb:	00 
801057ec:	66 89 0c c5 02 4f 11 	mov    %cx,-0x7feeb0fe(,%eax,8)
801057f3:	80 
801057f4:	c6 04 c5 05 4f 11 80 	movb   $0x8e,-0x7feeb0fb(,%eax,8)
801057fb:	8e 
801057fc:	66 89 14 c5 00 4f 11 	mov    %dx,-0x7feeb100(,%eax,8)
80105803:	80 
80105804:	c1 ea 10             	shr    $0x10,%edx
80105807:	66 89 14 c5 06 4f 11 	mov    %dx,-0x7feeb0fa(,%eax,8)
8010580e:	80 
void
tvinit(void)
{
  int i;

  for(i = 0; i < 256; i++)
8010580f:	83 c0 01             	add    $0x1,%eax
80105812:	3d 00 01 00 00       	cmp    $0x100,%eax
80105817:	75 bf                	jne    801057d8 <tvinit+0x8>
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
80105819:	55                   	push   %ebp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
8010581a:	ba 08 00 00 00       	mov    $0x8,%edx
struct spinlock tickslock;
uint ticks;

void
tvinit(void)
{
8010581f:	89 e5                	mov    %esp,%ebp
80105821:	83 ec 10             	sub    $0x10,%esp
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105824:	a1 7c a1 10 80       	mov    0x8010a17c,%eax

  initlock(&tickslock, "time");
80105829:	68 4b 78 10 80       	push   $0x8010784b
8010582e:	68 c0 4e 11 80       	push   $0x80114ec0
{
  int i;

  for(i = 0; i < 256; i++)
    SETGATE(idt[i], 0, SEG_KCODE<<3, vectors[i], 0);
  SETGATE(idt[T_SYSCALL], 1, SEG_KCODE<<3, vectors[T_SYSCALL], DPL_USER);
80105833:	66 89 15 02 51 11 80 	mov    %dx,0x80115102
8010583a:	c6 05 04 51 11 80 00 	movb   $0x0,0x80115104
80105841:	66 a3 00 51 11 80    	mov    %ax,0x80115100
80105847:	c1 e8 10             	shr    $0x10,%eax
8010584a:	c6 05 05 51 11 80 ef 	movb   $0xef,0x80115105
80105851:	66 a3 06 51 11 80    	mov    %ax,0x80115106

  initlock(&tickslock, "time");
80105857:	e8 94 e9 ff ff       	call   801041f0 <initlock>
}
8010585c:	83 c4 10             	add    $0x10,%esp
8010585f:	c9                   	leave  
80105860:	c3                   	ret    
80105861:	eb 0d                	jmp    80105870 <idtinit>
80105863:	90                   	nop
80105864:	90                   	nop
80105865:	90                   	nop
80105866:	90                   	nop
80105867:	90                   	nop
80105868:	90                   	nop
80105869:	90                   	nop
8010586a:	90                   	nop
8010586b:	90                   	nop
8010586c:	90                   	nop
8010586d:	90                   	nop
8010586e:	90                   	nop
8010586f:	90                   	nop

80105870 <idtinit>:

void
idtinit(void)
{
80105870:	55                   	push   %ebp
static inline void
lidt(struct gatedesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
80105871:	b8 ff 07 00 00       	mov    $0x7ff,%eax
80105876:	89 e5                	mov    %esp,%ebp
80105878:	83 ec 10             	sub    $0x10,%esp
8010587b:	66 89 45 fa          	mov    %ax,-0x6(%ebp)
  pd[1] = (uint)p;
8010587f:	b8 00 4f 11 80       	mov    $0x80114f00,%eax
80105884:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
  pd[2] = (uint)p >> 16;
80105888:	c1 e8 10             	shr    $0x10,%eax
8010588b:	66 89 45 fe          	mov    %ax,-0x2(%ebp)

  asm volatile("lidt (%0)" : : "r" (pd));
8010588f:	8d 45 fa             	lea    -0x6(%ebp),%eax
80105892:	0f 01 18             	lidtl  (%eax)
  lidt(idt, sizeof(idt));
}
80105895:	c9                   	leave  
80105896:	c3                   	ret    
80105897:	89 f6                	mov    %esi,%esi
80105899:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801058a0 <trap>:

//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
801058a0:	55                   	push   %ebp
801058a1:	89 e5                	mov    %esp,%ebp
801058a3:	57                   	push   %edi
801058a4:	56                   	push   %esi
801058a5:	53                   	push   %ebx
801058a6:	83 ec 1c             	sub    $0x1c,%esp
801058a9:	8b 7d 08             	mov    0x8(%ebp),%edi
  if(tf->trapno == T_SYSCALL){
801058ac:	8b 47 30             	mov    0x30(%edi),%eax
801058af:	83 f8 40             	cmp    $0x40,%eax
801058b2:	0f 84 88 01 00 00    	je     80105a40 <trap+0x1a0>
    if(myproc()->killed)
      exit();
    return;
  }

  switch(tf->trapno){
801058b8:	83 e8 20             	sub    $0x20,%eax
801058bb:	83 f8 1f             	cmp    $0x1f,%eax
801058be:	77 10                	ja     801058d0 <trap+0x30>
801058c0:	ff 24 85 14 79 10 80 	jmp    *-0x7fef86ec(,%eax,4)
801058c7:	89 f6                	mov    %esi,%esi
801058c9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
    lapiceoi();
    break;

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
801058d0:	e8 cb de ff ff       	call   801037a0 <myproc>
801058d5:	85 c0                	test   %eax,%eax
801058d7:	0f 84 d7 01 00 00    	je     80105ab4 <trap+0x214>
801058dd:	f6 47 3c 03          	testb  $0x3,0x3c(%edi)
801058e1:	0f 84 cd 01 00 00    	je     80105ab4 <trap+0x214>

static inline uint
rcr2(void)
{
  uint val;
  asm volatile("movl %%cr2,%0" : "=r" (val));
801058e7:	0f 20 d1             	mov    %cr2,%ecx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
801058ea:	8b 57 38             	mov    0x38(%edi),%edx
801058ed:	89 4d d8             	mov    %ecx,-0x28(%ebp)
801058f0:	89 55 dc             	mov    %edx,-0x24(%ebp)
801058f3:	e8 88 de ff ff       	call   80103780 <cpuid>
801058f8:	8b 77 34             	mov    0x34(%edi),%esi
801058fb:	8b 5f 30             	mov    0x30(%edi),%ebx
801058fe:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105901:	e8 9a de ff ff       	call   801037a0 <myproc>
80105906:	89 45 e0             	mov    %eax,-0x20(%ebp)
80105909:	e8 92 de ff ff       	call   801037a0 <myproc>
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
8010590e:	8b 4d d8             	mov    -0x28(%ebp),%ecx
80105911:	8b 55 dc             	mov    -0x24(%ebp),%edx
80105914:	51                   	push   %ecx
80105915:	52                   	push   %edx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
80105916:	8b 55 e0             	mov    -0x20(%ebp),%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105919:	ff 75 e4             	pushl  -0x1c(%ebp)
8010591c:	56                   	push   %esi
8010591d:	53                   	push   %ebx
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
8010591e:	83 c2 74             	add    $0x74,%edx
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
    }
    // In user space, assume process misbehaved.
    cprintf("pid %d %s: trap %d err %d on cpu %d "
80105921:	52                   	push   %edx
80105922:	ff 70 18             	pushl  0x18(%eax)
80105925:	68 d0 78 10 80       	push   $0x801078d0
8010592a:	e8 31 ad ff ff       	call   80100660 <cprintf>
            "eip 0x%x addr 0x%x--kill proc\n",
            myproc()->pid, myproc()->name, tf->trapno,
            tf->err, cpuid(), tf->eip, rcr2());
    myproc()->killed = 1;
8010592f:	83 c4 20             	add    $0x20,%esp
80105932:	e8 69 de ff ff       	call   801037a0 <myproc>
80105937:	c7 40 2c 01 00 00 00 	movl   $0x1,0x2c(%eax)
8010593e:	66 90                	xchg   %ax,%ax
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105940:	e8 5b de ff ff       	call   801037a0 <myproc>
80105945:	85 c0                	test   %eax,%eax
80105947:	74 0c                	je     80105955 <trap+0xb5>
80105949:	e8 52 de ff ff       	call   801037a0 <myproc>
8010594e:	8b 50 2c             	mov    0x2c(%eax),%edx
80105951:	85 d2                	test   %edx,%edx
80105953:	75 4b                	jne    801059a0 <trap+0x100>
    exit();

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
80105955:	e8 46 de ff ff       	call   801037a0 <myproc>
8010595a:	85 c0                	test   %eax,%eax
8010595c:	74 0b                	je     80105969 <trap+0xc9>
8010595e:	e8 3d de ff ff       	call   801037a0 <myproc>
80105963:	83 78 14 04          	cmpl   $0x4,0x14(%eax)
80105967:	74 4f                	je     801059b8 <trap+0x118>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
80105969:	e8 32 de ff ff       	call   801037a0 <myproc>
8010596e:	85 c0                	test   %eax,%eax
80105970:	74 1d                	je     8010598f <trap+0xef>
80105972:	e8 29 de ff ff       	call   801037a0 <myproc>
80105977:	8b 40 2c             	mov    0x2c(%eax),%eax
8010597a:	85 c0                	test   %eax,%eax
8010597c:	74 11                	je     8010598f <trap+0xef>
8010597e:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
80105982:	83 e0 03             	and    $0x3,%eax
80105985:	66 83 f8 03          	cmp    $0x3,%ax
80105989:	0f 84 da 00 00 00    	je     80105a69 <trap+0x1c9>
    exit();
}
8010598f:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105992:	5b                   	pop    %ebx
80105993:	5e                   	pop    %esi
80105994:	5f                   	pop    %edi
80105995:	5d                   	pop    %ebp
80105996:	c3                   	ret    
80105997:	89 f6                	mov    %esi,%esi
80105999:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  }

  // Force process exit if it has been killed and is in user space.
  // (If it is still executing in the kernel, let it keep running
  // until it gets to the regular system call return.)
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
801059a0:	0f b7 47 3c          	movzwl 0x3c(%edi),%eax
801059a4:	83 e0 03             	and    $0x3,%eax
801059a7:	66 83 f8 03          	cmp    $0x3,%ax
801059ab:	75 a8                	jne    80105955 <trap+0xb5>
    exit();
801059ad:	e8 1e e2 ff ff       	call   80103bd0 <exit>
801059b2:	eb a1                	jmp    80105955 <trap+0xb5>
801059b4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  // Force process to give up CPU on clock tick.
  // If interrupts were on while locks held, would need to check nlock.
  if(myproc() && myproc()->state == RUNNING &&
801059b8:	83 7f 30 20          	cmpl   $0x20,0x30(%edi)
801059bc:	75 ab                	jne    80105969 <trap+0xc9>
     tf->trapno == T_IRQ0+IRQ_TIMER)
    yield();
801059be:	e8 3d e3 ff ff       	call   80103d00 <yield>
801059c3:	eb a4                	jmp    80105969 <trap+0xc9>
801059c5:	8d 76 00             	lea    0x0(%esi),%esi
    return;
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
801059c8:	e8 b3 dd ff ff       	call   80103780 <cpuid>
801059cd:	85 c0                	test   %eax,%eax
801059cf:	0f 84 ab 00 00 00    	je     80105a80 <trap+0x1e0>
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
    lapiceoi();
801059d5:	e8 36 cd ff ff       	call   80102710 <lapiceoi>
    break;
801059da:	e9 61 ff ff ff       	jmp    80105940 <trap+0xa0>
801059df:	90                   	nop
  case T_IRQ0 + IRQ_IDE+1:
    // Bochs generates spurious IDE1 interrupts.
    break;
  case T_IRQ0 + IRQ_KBD:
    kbdintr();
801059e0:	e8 eb cb ff ff       	call   801025d0 <kbdintr>
    lapiceoi();
801059e5:	e8 26 cd ff ff       	call   80102710 <lapiceoi>
    break;
801059ea:	e9 51 ff ff ff       	jmp    80105940 <trap+0xa0>
801059ef:	90                   	nop
  case T_IRQ0 + IRQ_COM1:
    uartintr();
801059f0:	e8 5b 02 00 00       	call   80105c50 <uartintr>
    lapiceoi();
801059f5:	e8 16 cd ff ff       	call   80102710 <lapiceoi>
    break;
801059fa:	e9 41 ff ff ff       	jmp    80105940 <trap+0xa0>
801059ff:	90                   	nop
  case T_IRQ0 + 7:
  case T_IRQ0 + IRQ_SPURIOUS:
    cprintf("cpu%d: spurious interrupt at %x:%x\n",
80105a00:	0f b7 5f 3c          	movzwl 0x3c(%edi),%ebx
80105a04:	8b 77 38             	mov    0x38(%edi),%esi
80105a07:	e8 74 dd ff ff       	call   80103780 <cpuid>
80105a0c:	56                   	push   %esi
80105a0d:	53                   	push   %ebx
80105a0e:	50                   	push   %eax
80105a0f:	68 78 78 10 80       	push   $0x80107878
80105a14:	e8 47 ac ff ff       	call   80100660 <cprintf>
            cpuid(), tf->cs, tf->eip);
    lapiceoi();
80105a19:	e8 f2 cc ff ff       	call   80102710 <lapiceoi>
    break;
80105a1e:	83 c4 10             	add    $0x10,%esp
80105a21:	e9 1a ff ff ff       	jmp    80105940 <trap+0xa0>
80105a26:	8d 76 00             	lea    0x0(%esi),%esi
80105a29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
      release(&tickslock);
    }
    lapiceoi();
    break;
  case T_IRQ0 + IRQ_IDE:
    ideintr();
80105a30:	e8 1b c6 ff ff       	call   80102050 <ideintr>
80105a35:	eb 9e                	jmp    801059d5 <trap+0x135>
80105a37:	89 f6                	mov    %esi,%esi
80105a39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
//PAGEBREAK: 41
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
80105a40:	e8 5b dd ff ff       	call   801037a0 <myproc>
80105a45:	8b 58 2c             	mov    0x2c(%eax),%ebx
80105a48:	85 db                	test   %ebx,%ebx
80105a4a:	75 2c                	jne    80105a78 <trap+0x1d8>
      exit();
    myproc()->tf = tf;
80105a4c:	e8 4f dd ff ff       	call   801037a0 <myproc>
80105a51:	89 78 20             	mov    %edi,0x20(%eax)
    syscall();
80105a54:	e8 f7 ed ff ff       	call   80104850 <syscall>
    if(myproc()->killed)
80105a59:	e8 42 dd ff ff       	call   801037a0 <myproc>
80105a5e:	8b 48 2c             	mov    0x2c(%eax),%ecx
80105a61:	85 c9                	test   %ecx,%ecx
80105a63:	0f 84 26 ff ff ff    	je     8010598f <trap+0xef>
    yield();

  // Check if the process has been killed since we yielded
  if(myproc() && myproc()->killed && (tf->cs&3) == DPL_USER)
    exit();
}
80105a69:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105a6c:	5b                   	pop    %ebx
80105a6d:	5e                   	pop    %esi
80105a6e:	5f                   	pop    %edi
80105a6f:	5d                   	pop    %ebp
    if(myproc()->killed)
      exit();
    myproc()->tf = tf;
    syscall();
    if(myproc()->killed)
      exit();
80105a70:	e9 5b e1 ff ff       	jmp    80103bd0 <exit>
80105a75:	8d 76 00             	lea    0x0(%esi),%esi
void
trap(struct trapframe *tf)
{
  if(tf->trapno == T_SYSCALL){
    if(myproc()->killed)
      exit();
80105a78:	e8 53 e1 ff ff       	call   80103bd0 <exit>
80105a7d:	eb cd                	jmp    80105a4c <trap+0x1ac>
80105a7f:	90                   	nop
  }

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
80105a80:	83 ec 0c             	sub    $0xc,%esp
80105a83:	68 c0 4e 11 80       	push   $0x80114ec0
80105a88:	e8 c3 e8 ff ff       	call   80104350 <acquire>
      ticks++;
      wakeup(&ticks);
80105a8d:	c7 04 24 00 57 11 80 	movl   $0x80115700,(%esp)

  switch(tf->trapno){
  case T_IRQ0 + IRQ_TIMER:
    if(cpuid() == 0){
      acquire(&tickslock);
      ticks++;
80105a94:	83 05 00 57 11 80 01 	addl   $0x1,0x80115700
      wakeup(&ticks);
80105a9b:	e8 70 e4 ff ff       	call   80103f10 <wakeup>
      release(&tickslock);
80105aa0:	c7 04 24 c0 4e 11 80 	movl   $0x80114ec0,(%esp)
80105aa7:	e8 54 e9 ff ff       	call   80104400 <release>
80105aac:	83 c4 10             	add    $0x10,%esp
80105aaf:	e9 21 ff ff ff       	jmp    801059d5 <trap+0x135>
80105ab4:	0f 20 d6             	mov    %cr2,%esi

  //PAGEBREAK: 13
  default:
    if(myproc() == 0 || (tf->cs&3) == 0){
      // In kernel, it must be our mistake.
      cprintf("unexpected trap %d from cpu %d eip %x (cr2=0x%x)\n",
80105ab7:	8b 5f 38             	mov    0x38(%edi),%ebx
80105aba:	e8 c1 dc ff ff       	call   80103780 <cpuid>
80105abf:	83 ec 0c             	sub    $0xc,%esp
80105ac2:	56                   	push   %esi
80105ac3:	53                   	push   %ebx
80105ac4:	50                   	push   %eax
80105ac5:	ff 77 30             	pushl  0x30(%edi)
80105ac8:	68 9c 78 10 80       	push   $0x8010789c
80105acd:	e8 8e ab ff ff       	call   80100660 <cprintf>
              tf->trapno, cpuid(), tf->eip, rcr2());
      panic("trap");
80105ad2:	83 c4 14             	add    $0x14,%esp
80105ad5:	68 70 78 10 80       	push   $0x80107870
80105ada:	e8 91 a8 ff ff       	call   80100370 <panic>
80105adf:	90                   	nop

80105ae0 <uartgetc>:
}

static int
uartgetc(void)
{
  if(!uart)
80105ae0:	a1 1c a6 10 80       	mov    0x8010a61c,%eax
  outb(COM1+0, c);
}

static int
uartgetc(void)
{
80105ae5:	55                   	push   %ebp
80105ae6:	89 e5                	mov    %esp,%ebp
  if(!uart)
80105ae8:	85 c0                	test   %eax,%eax
80105aea:	74 1c                	je     80105b08 <uartgetc+0x28>
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105aec:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105af1:	ec                   	in     (%dx),%al
    return -1;
  if(!(inb(COM1+5) & 0x01))
80105af2:	a8 01                	test   $0x1,%al
80105af4:	74 12                	je     80105b08 <uartgetc+0x28>
80105af6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105afb:	ec                   	in     (%dx),%al
    return -1;
  return inb(COM1+0);
80105afc:	0f b6 c0             	movzbl %al,%eax
}
80105aff:	5d                   	pop    %ebp
80105b00:	c3                   	ret    
80105b01:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

static int
uartgetc(void)
{
  if(!uart)
    return -1;
80105b08:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  if(!(inb(COM1+5) & 0x01))
    return -1;
  return inb(COM1+0);
}
80105b0d:	5d                   	pop    %ebp
80105b0e:	c3                   	ret    
80105b0f:	90                   	nop

80105b10 <uartputc.part.0>:
  for(p="xv6...\n"; *p; p++)
    uartputc(*p);
}

void
uartputc(int c)
80105b10:	55                   	push   %ebp
80105b11:	89 e5                	mov    %esp,%ebp
80105b13:	57                   	push   %edi
80105b14:	56                   	push   %esi
80105b15:	53                   	push   %ebx
80105b16:	89 c7                	mov    %eax,%edi
80105b18:	bb 80 00 00 00       	mov    $0x80,%ebx
80105b1d:	be fd 03 00 00       	mov    $0x3fd,%esi
80105b22:	83 ec 0c             	sub    $0xc,%esp
80105b25:	eb 1b                	jmp    80105b42 <uartputc.part.0+0x32>
80105b27:	89 f6                	mov    %esi,%esi
80105b29:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
80105b30:	83 ec 0c             	sub    $0xc,%esp
80105b33:	6a 0a                	push   $0xa
80105b35:	e8 f6 cb ff ff       	call   80102730 <microdelay>
{
  int i;

  if(!uart)
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
80105b3a:	83 c4 10             	add    $0x10,%esp
80105b3d:	83 eb 01             	sub    $0x1,%ebx
80105b40:	74 07                	je     80105b49 <uartputc.part.0+0x39>
80105b42:	89 f2                	mov    %esi,%edx
80105b44:	ec                   	in     (%dx),%al
80105b45:	a8 20                	test   $0x20,%al
80105b47:	74 e7                	je     80105b30 <uartputc.part.0+0x20>
}

static inline void
outb(ushort port, uchar data)
{
  asm volatile("out %0,%1" : : "a" (data), "d" (port));
80105b49:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b4e:	89 f8                	mov    %edi,%eax
80105b50:	ee                   	out    %al,(%dx)
    microdelay(10);
  outb(COM1+0, c);
}
80105b51:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105b54:	5b                   	pop    %ebx
80105b55:	5e                   	pop    %esi
80105b56:	5f                   	pop    %edi
80105b57:	5d                   	pop    %ebp
80105b58:	c3                   	ret    
80105b59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80105b60 <uartinit>:

static int uart;    // is there a uart?

void
uartinit(void)
{
80105b60:	55                   	push   %ebp
80105b61:	31 c9                	xor    %ecx,%ecx
80105b63:	89 c8                	mov    %ecx,%eax
80105b65:	89 e5                	mov    %esp,%ebp
80105b67:	57                   	push   %edi
80105b68:	56                   	push   %esi
80105b69:	53                   	push   %ebx
80105b6a:	bb fa 03 00 00       	mov    $0x3fa,%ebx
80105b6f:	89 da                	mov    %ebx,%edx
80105b71:	83 ec 0c             	sub    $0xc,%esp
80105b74:	ee                   	out    %al,(%dx)
80105b75:	bf fb 03 00 00       	mov    $0x3fb,%edi
80105b7a:	b8 80 ff ff ff       	mov    $0xffffff80,%eax
80105b7f:	89 fa                	mov    %edi,%edx
80105b81:	ee                   	out    %al,(%dx)
80105b82:	b8 0c 00 00 00       	mov    $0xc,%eax
80105b87:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105b8c:	ee                   	out    %al,(%dx)
80105b8d:	be f9 03 00 00       	mov    $0x3f9,%esi
80105b92:	89 c8                	mov    %ecx,%eax
80105b94:	89 f2                	mov    %esi,%edx
80105b96:	ee                   	out    %al,(%dx)
80105b97:	b8 03 00 00 00       	mov    $0x3,%eax
80105b9c:	89 fa                	mov    %edi,%edx
80105b9e:	ee                   	out    %al,(%dx)
80105b9f:	ba fc 03 00 00       	mov    $0x3fc,%edx
80105ba4:	89 c8                	mov    %ecx,%eax
80105ba6:	ee                   	out    %al,(%dx)
80105ba7:	b8 01 00 00 00       	mov    $0x1,%eax
80105bac:	89 f2                	mov    %esi,%edx
80105bae:	ee                   	out    %al,(%dx)
static inline uchar
inb(ushort port)
{
  uchar data;

  asm volatile("in %1,%0" : "=a" (data) : "d" (port));
80105baf:	ba fd 03 00 00       	mov    $0x3fd,%edx
80105bb4:	ec                   	in     (%dx),%al
  outb(COM1+3, 0x03);    // Lock divisor, 8 data bits.
  outb(COM1+4, 0);
  outb(COM1+1, 0x01);    // Enable receive interrupts.

  // If status is 0xFF, no serial port.
  if(inb(COM1+5) == 0xFF)
80105bb5:	3c ff                	cmp    $0xff,%al
80105bb7:	74 5a                	je     80105c13 <uartinit+0xb3>
    return;
  uart = 1;
80105bb9:	c7 05 1c a6 10 80 01 	movl   $0x1,0x8010a61c
80105bc0:	00 00 00 
80105bc3:	89 da                	mov    %ebx,%edx
80105bc5:	ec                   	in     (%dx),%al
80105bc6:	ba f8 03 00 00       	mov    $0x3f8,%edx
80105bcb:	ec                   	in     (%dx),%al

  // Acknowledge pre-existing interrupt conditions;
  // enable interrupts.
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);
80105bcc:	83 ec 08             	sub    $0x8,%esp
80105bcf:	bb 94 79 10 80       	mov    $0x80107994,%ebx
80105bd4:	6a 00                	push   $0x0
80105bd6:	6a 04                	push   $0x4
80105bd8:	e8 c3 c6 ff ff       	call   801022a0 <ioapicenable>
80105bdd:	83 c4 10             	add    $0x10,%esp
80105be0:	b8 78 00 00 00       	mov    $0x78,%eax
80105be5:	eb 13                	jmp    80105bfa <uartinit+0x9a>
80105be7:	89 f6                	mov    %esi,%esi
80105be9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105bf0:	83 c3 01             	add    $0x1,%ebx
80105bf3:	0f be 03             	movsbl (%ebx),%eax
80105bf6:	84 c0                	test   %al,%al
80105bf8:	74 19                	je     80105c13 <uartinit+0xb3>
void
uartputc(int c)
{
  int i;

  if(!uart)
80105bfa:	8b 15 1c a6 10 80    	mov    0x8010a61c,%edx
80105c00:	85 d2                	test   %edx,%edx
80105c02:	74 ec                	je     80105bf0 <uartinit+0x90>
  inb(COM1+2);
  inb(COM1+0);
  ioapicenable(IRQ_COM1, 0);

  // Announce that we're here.
  for(p="xv6...\n"; *p; p++)
80105c04:	83 c3 01             	add    $0x1,%ebx
80105c07:	e8 04 ff ff ff       	call   80105b10 <uartputc.part.0>
80105c0c:	0f be 03             	movsbl (%ebx),%eax
80105c0f:	84 c0                	test   %al,%al
80105c11:	75 e7                	jne    80105bfa <uartinit+0x9a>
    uartputc(*p);
}
80105c13:	8d 65 f4             	lea    -0xc(%ebp),%esp
80105c16:	5b                   	pop    %ebx
80105c17:	5e                   	pop    %esi
80105c18:	5f                   	pop    %edi
80105c19:	5d                   	pop    %ebp
80105c1a:	c3                   	ret    
80105c1b:	90                   	nop
80105c1c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80105c20 <uartputc>:
void
uartputc(int c)
{
  int i;

  if(!uart)
80105c20:	8b 15 1c a6 10 80    	mov    0x8010a61c,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105c26:	55                   	push   %ebp
80105c27:	89 e5                	mov    %esp,%ebp
  int i;

  if(!uart)
80105c29:	85 d2                	test   %edx,%edx
    uartputc(*p);
}

void
uartputc(int c)
{
80105c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  int i;

  if(!uart)
80105c2e:	74 10                	je     80105c40 <uartputc+0x20>
    return;
  for(i = 0; i < 128 && !(inb(COM1+5) & 0x20); i++)
    microdelay(10);
  outb(COM1+0, c);
}
80105c30:	5d                   	pop    %ebp
80105c31:	e9 da fe ff ff       	jmp    80105b10 <uartputc.part.0>
80105c36:	8d 76 00             	lea    0x0(%esi),%esi
80105c39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80105c40:	5d                   	pop    %ebp
80105c41:	c3                   	ret    
80105c42:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80105c49:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80105c50 <uartintr>:
  return inb(COM1+0);
}

void
uartintr(void)
{
80105c50:	55                   	push   %ebp
80105c51:	89 e5                	mov    %esp,%ebp
80105c53:	83 ec 14             	sub    $0x14,%esp
  consoleintr(uartgetc);
80105c56:	68 e0 5a 10 80       	push   $0x80105ae0
80105c5b:	e8 90 ab ff ff       	call   801007f0 <consoleintr>
}
80105c60:	83 c4 10             	add    $0x10,%esp
80105c63:	c9                   	leave  
80105c64:	c3                   	ret    

80105c65 <vector0>:
# generated by vectors.pl - do not edit
# handlers
.globl alltraps
.globl vector0
vector0:
  pushl $0
80105c65:	6a 00                	push   $0x0
  pushl $0
80105c67:	6a 00                	push   $0x0
  jmp alltraps
80105c69:	e9 39 fb ff ff       	jmp    801057a7 <alltraps>

80105c6e <vector1>:
.globl vector1
vector1:
  pushl $0
80105c6e:	6a 00                	push   $0x0
  pushl $1
80105c70:	6a 01                	push   $0x1
  jmp alltraps
80105c72:	e9 30 fb ff ff       	jmp    801057a7 <alltraps>

80105c77 <vector2>:
.globl vector2
vector2:
  pushl $0
80105c77:	6a 00                	push   $0x0
  pushl $2
80105c79:	6a 02                	push   $0x2
  jmp alltraps
80105c7b:	e9 27 fb ff ff       	jmp    801057a7 <alltraps>

80105c80 <vector3>:
.globl vector3
vector3:
  pushl $0
80105c80:	6a 00                	push   $0x0
  pushl $3
80105c82:	6a 03                	push   $0x3
  jmp alltraps
80105c84:	e9 1e fb ff ff       	jmp    801057a7 <alltraps>

80105c89 <vector4>:
.globl vector4
vector4:
  pushl $0
80105c89:	6a 00                	push   $0x0
  pushl $4
80105c8b:	6a 04                	push   $0x4
  jmp alltraps
80105c8d:	e9 15 fb ff ff       	jmp    801057a7 <alltraps>

80105c92 <vector5>:
.globl vector5
vector5:
  pushl $0
80105c92:	6a 00                	push   $0x0
  pushl $5
80105c94:	6a 05                	push   $0x5
  jmp alltraps
80105c96:	e9 0c fb ff ff       	jmp    801057a7 <alltraps>

80105c9b <vector6>:
.globl vector6
vector6:
  pushl $0
80105c9b:	6a 00                	push   $0x0
  pushl $6
80105c9d:	6a 06                	push   $0x6
  jmp alltraps
80105c9f:	e9 03 fb ff ff       	jmp    801057a7 <alltraps>

80105ca4 <vector7>:
.globl vector7
vector7:
  pushl $0
80105ca4:	6a 00                	push   $0x0
  pushl $7
80105ca6:	6a 07                	push   $0x7
  jmp alltraps
80105ca8:	e9 fa fa ff ff       	jmp    801057a7 <alltraps>

80105cad <vector8>:
.globl vector8
vector8:
  pushl $8
80105cad:	6a 08                	push   $0x8
  jmp alltraps
80105caf:	e9 f3 fa ff ff       	jmp    801057a7 <alltraps>

80105cb4 <vector9>:
.globl vector9
vector9:
  pushl $0
80105cb4:	6a 00                	push   $0x0
  pushl $9
80105cb6:	6a 09                	push   $0x9
  jmp alltraps
80105cb8:	e9 ea fa ff ff       	jmp    801057a7 <alltraps>

80105cbd <vector10>:
.globl vector10
vector10:
  pushl $10
80105cbd:	6a 0a                	push   $0xa
  jmp alltraps
80105cbf:	e9 e3 fa ff ff       	jmp    801057a7 <alltraps>

80105cc4 <vector11>:
.globl vector11
vector11:
  pushl $11
80105cc4:	6a 0b                	push   $0xb
  jmp alltraps
80105cc6:	e9 dc fa ff ff       	jmp    801057a7 <alltraps>

80105ccb <vector12>:
.globl vector12
vector12:
  pushl $12
80105ccb:	6a 0c                	push   $0xc
  jmp alltraps
80105ccd:	e9 d5 fa ff ff       	jmp    801057a7 <alltraps>

80105cd2 <vector13>:
.globl vector13
vector13:
  pushl $13
80105cd2:	6a 0d                	push   $0xd
  jmp alltraps
80105cd4:	e9 ce fa ff ff       	jmp    801057a7 <alltraps>

80105cd9 <vector14>:
.globl vector14
vector14:
  pushl $14
80105cd9:	6a 0e                	push   $0xe
  jmp alltraps
80105cdb:	e9 c7 fa ff ff       	jmp    801057a7 <alltraps>

80105ce0 <vector15>:
.globl vector15
vector15:
  pushl $0
80105ce0:	6a 00                	push   $0x0
  pushl $15
80105ce2:	6a 0f                	push   $0xf
  jmp alltraps
80105ce4:	e9 be fa ff ff       	jmp    801057a7 <alltraps>

80105ce9 <vector16>:
.globl vector16
vector16:
  pushl $0
80105ce9:	6a 00                	push   $0x0
  pushl $16
80105ceb:	6a 10                	push   $0x10
  jmp alltraps
80105ced:	e9 b5 fa ff ff       	jmp    801057a7 <alltraps>

80105cf2 <vector17>:
.globl vector17
vector17:
  pushl $17
80105cf2:	6a 11                	push   $0x11
  jmp alltraps
80105cf4:	e9 ae fa ff ff       	jmp    801057a7 <alltraps>

80105cf9 <vector18>:
.globl vector18
vector18:
  pushl $0
80105cf9:	6a 00                	push   $0x0
  pushl $18
80105cfb:	6a 12                	push   $0x12
  jmp alltraps
80105cfd:	e9 a5 fa ff ff       	jmp    801057a7 <alltraps>

80105d02 <vector19>:
.globl vector19
vector19:
  pushl $0
80105d02:	6a 00                	push   $0x0
  pushl $19
80105d04:	6a 13                	push   $0x13
  jmp alltraps
80105d06:	e9 9c fa ff ff       	jmp    801057a7 <alltraps>

80105d0b <vector20>:
.globl vector20
vector20:
  pushl $0
80105d0b:	6a 00                	push   $0x0
  pushl $20
80105d0d:	6a 14                	push   $0x14
  jmp alltraps
80105d0f:	e9 93 fa ff ff       	jmp    801057a7 <alltraps>

80105d14 <vector21>:
.globl vector21
vector21:
  pushl $0
80105d14:	6a 00                	push   $0x0
  pushl $21
80105d16:	6a 15                	push   $0x15
  jmp alltraps
80105d18:	e9 8a fa ff ff       	jmp    801057a7 <alltraps>

80105d1d <vector22>:
.globl vector22
vector22:
  pushl $0
80105d1d:	6a 00                	push   $0x0
  pushl $22
80105d1f:	6a 16                	push   $0x16
  jmp alltraps
80105d21:	e9 81 fa ff ff       	jmp    801057a7 <alltraps>

80105d26 <vector23>:
.globl vector23
vector23:
  pushl $0
80105d26:	6a 00                	push   $0x0
  pushl $23
80105d28:	6a 17                	push   $0x17
  jmp alltraps
80105d2a:	e9 78 fa ff ff       	jmp    801057a7 <alltraps>

80105d2f <vector24>:
.globl vector24
vector24:
  pushl $0
80105d2f:	6a 00                	push   $0x0
  pushl $24
80105d31:	6a 18                	push   $0x18
  jmp alltraps
80105d33:	e9 6f fa ff ff       	jmp    801057a7 <alltraps>

80105d38 <vector25>:
.globl vector25
vector25:
  pushl $0
80105d38:	6a 00                	push   $0x0
  pushl $25
80105d3a:	6a 19                	push   $0x19
  jmp alltraps
80105d3c:	e9 66 fa ff ff       	jmp    801057a7 <alltraps>

80105d41 <vector26>:
.globl vector26
vector26:
  pushl $0
80105d41:	6a 00                	push   $0x0
  pushl $26
80105d43:	6a 1a                	push   $0x1a
  jmp alltraps
80105d45:	e9 5d fa ff ff       	jmp    801057a7 <alltraps>

80105d4a <vector27>:
.globl vector27
vector27:
  pushl $0
80105d4a:	6a 00                	push   $0x0
  pushl $27
80105d4c:	6a 1b                	push   $0x1b
  jmp alltraps
80105d4e:	e9 54 fa ff ff       	jmp    801057a7 <alltraps>

80105d53 <vector28>:
.globl vector28
vector28:
  pushl $0
80105d53:	6a 00                	push   $0x0
  pushl $28
80105d55:	6a 1c                	push   $0x1c
  jmp alltraps
80105d57:	e9 4b fa ff ff       	jmp    801057a7 <alltraps>

80105d5c <vector29>:
.globl vector29
vector29:
  pushl $0
80105d5c:	6a 00                	push   $0x0
  pushl $29
80105d5e:	6a 1d                	push   $0x1d
  jmp alltraps
80105d60:	e9 42 fa ff ff       	jmp    801057a7 <alltraps>

80105d65 <vector30>:
.globl vector30
vector30:
  pushl $0
80105d65:	6a 00                	push   $0x0
  pushl $30
80105d67:	6a 1e                	push   $0x1e
  jmp alltraps
80105d69:	e9 39 fa ff ff       	jmp    801057a7 <alltraps>

80105d6e <vector31>:
.globl vector31
vector31:
  pushl $0
80105d6e:	6a 00                	push   $0x0
  pushl $31
80105d70:	6a 1f                	push   $0x1f
  jmp alltraps
80105d72:	e9 30 fa ff ff       	jmp    801057a7 <alltraps>

80105d77 <vector32>:
.globl vector32
vector32:
  pushl $0
80105d77:	6a 00                	push   $0x0
  pushl $32
80105d79:	6a 20                	push   $0x20
  jmp alltraps
80105d7b:	e9 27 fa ff ff       	jmp    801057a7 <alltraps>

80105d80 <vector33>:
.globl vector33
vector33:
  pushl $0
80105d80:	6a 00                	push   $0x0
  pushl $33
80105d82:	6a 21                	push   $0x21
  jmp alltraps
80105d84:	e9 1e fa ff ff       	jmp    801057a7 <alltraps>

80105d89 <vector34>:
.globl vector34
vector34:
  pushl $0
80105d89:	6a 00                	push   $0x0
  pushl $34
80105d8b:	6a 22                	push   $0x22
  jmp alltraps
80105d8d:	e9 15 fa ff ff       	jmp    801057a7 <alltraps>

80105d92 <vector35>:
.globl vector35
vector35:
  pushl $0
80105d92:	6a 00                	push   $0x0
  pushl $35
80105d94:	6a 23                	push   $0x23
  jmp alltraps
80105d96:	e9 0c fa ff ff       	jmp    801057a7 <alltraps>

80105d9b <vector36>:
.globl vector36
vector36:
  pushl $0
80105d9b:	6a 00                	push   $0x0
  pushl $36
80105d9d:	6a 24                	push   $0x24
  jmp alltraps
80105d9f:	e9 03 fa ff ff       	jmp    801057a7 <alltraps>

80105da4 <vector37>:
.globl vector37
vector37:
  pushl $0
80105da4:	6a 00                	push   $0x0
  pushl $37
80105da6:	6a 25                	push   $0x25
  jmp alltraps
80105da8:	e9 fa f9 ff ff       	jmp    801057a7 <alltraps>

80105dad <vector38>:
.globl vector38
vector38:
  pushl $0
80105dad:	6a 00                	push   $0x0
  pushl $38
80105daf:	6a 26                	push   $0x26
  jmp alltraps
80105db1:	e9 f1 f9 ff ff       	jmp    801057a7 <alltraps>

80105db6 <vector39>:
.globl vector39
vector39:
  pushl $0
80105db6:	6a 00                	push   $0x0
  pushl $39
80105db8:	6a 27                	push   $0x27
  jmp alltraps
80105dba:	e9 e8 f9 ff ff       	jmp    801057a7 <alltraps>

80105dbf <vector40>:
.globl vector40
vector40:
  pushl $0
80105dbf:	6a 00                	push   $0x0
  pushl $40
80105dc1:	6a 28                	push   $0x28
  jmp alltraps
80105dc3:	e9 df f9 ff ff       	jmp    801057a7 <alltraps>

80105dc8 <vector41>:
.globl vector41
vector41:
  pushl $0
80105dc8:	6a 00                	push   $0x0
  pushl $41
80105dca:	6a 29                	push   $0x29
  jmp alltraps
80105dcc:	e9 d6 f9 ff ff       	jmp    801057a7 <alltraps>

80105dd1 <vector42>:
.globl vector42
vector42:
  pushl $0
80105dd1:	6a 00                	push   $0x0
  pushl $42
80105dd3:	6a 2a                	push   $0x2a
  jmp alltraps
80105dd5:	e9 cd f9 ff ff       	jmp    801057a7 <alltraps>

80105dda <vector43>:
.globl vector43
vector43:
  pushl $0
80105dda:	6a 00                	push   $0x0
  pushl $43
80105ddc:	6a 2b                	push   $0x2b
  jmp alltraps
80105dde:	e9 c4 f9 ff ff       	jmp    801057a7 <alltraps>

80105de3 <vector44>:
.globl vector44
vector44:
  pushl $0
80105de3:	6a 00                	push   $0x0
  pushl $44
80105de5:	6a 2c                	push   $0x2c
  jmp alltraps
80105de7:	e9 bb f9 ff ff       	jmp    801057a7 <alltraps>

80105dec <vector45>:
.globl vector45
vector45:
  pushl $0
80105dec:	6a 00                	push   $0x0
  pushl $45
80105dee:	6a 2d                	push   $0x2d
  jmp alltraps
80105df0:	e9 b2 f9 ff ff       	jmp    801057a7 <alltraps>

80105df5 <vector46>:
.globl vector46
vector46:
  pushl $0
80105df5:	6a 00                	push   $0x0
  pushl $46
80105df7:	6a 2e                	push   $0x2e
  jmp alltraps
80105df9:	e9 a9 f9 ff ff       	jmp    801057a7 <alltraps>

80105dfe <vector47>:
.globl vector47
vector47:
  pushl $0
80105dfe:	6a 00                	push   $0x0
  pushl $47
80105e00:	6a 2f                	push   $0x2f
  jmp alltraps
80105e02:	e9 a0 f9 ff ff       	jmp    801057a7 <alltraps>

80105e07 <vector48>:
.globl vector48
vector48:
  pushl $0
80105e07:	6a 00                	push   $0x0
  pushl $48
80105e09:	6a 30                	push   $0x30
  jmp alltraps
80105e0b:	e9 97 f9 ff ff       	jmp    801057a7 <alltraps>

80105e10 <vector49>:
.globl vector49
vector49:
  pushl $0
80105e10:	6a 00                	push   $0x0
  pushl $49
80105e12:	6a 31                	push   $0x31
  jmp alltraps
80105e14:	e9 8e f9 ff ff       	jmp    801057a7 <alltraps>

80105e19 <vector50>:
.globl vector50
vector50:
  pushl $0
80105e19:	6a 00                	push   $0x0
  pushl $50
80105e1b:	6a 32                	push   $0x32
  jmp alltraps
80105e1d:	e9 85 f9 ff ff       	jmp    801057a7 <alltraps>

80105e22 <vector51>:
.globl vector51
vector51:
  pushl $0
80105e22:	6a 00                	push   $0x0
  pushl $51
80105e24:	6a 33                	push   $0x33
  jmp alltraps
80105e26:	e9 7c f9 ff ff       	jmp    801057a7 <alltraps>

80105e2b <vector52>:
.globl vector52
vector52:
  pushl $0
80105e2b:	6a 00                	push   $0x0
  pushl $52
80105e2d:	6a 34                	push   $0x34
  jmp alltraps
80105e2f:	e9 73 f9 ff ff       	jmp    801057a7 <alltraps>

80105e34 <vector53>:
.globl vector53
vector53:
  pushl $0
80105e34:	6a 00                	push   $0x0
  pushl $53
80105e36:	6a 35                	push   $0x35
  jmp alltraps
80105e38:	e9 6a f9 ff ff       	jmp    801057a7 <alltraps>

80105e3d <vector54>:
.globl vector54
vector54:
  pushl $0
80105e3d:	6a 00                	push   $0x0
  pushl $54
80105e3f:	6a 36                	push   $0x36
  jmp alltraps
80105e41:	e9 61 f9 ff ff       	jmp    801057a7 <alltraps>

80105e46 <vector55>:
.globl vector55
vector55:
  pushl $0
80105e46:	6a 00                	push   $0x0
  pushl $55
80105e48:	6a 37                	push   $0x37
  jmp alltraps
80105e4a:	e9 58 f9 ff ff       	jmp    801057a7 <alltraps>

80105e4f <vector56>:
.globl vector56
vector56:
  pushl $0
80105e4f:	6a 00                	push   $0x0
  pushl $56
80105e51:	6a 38                	push   $0x38
  jmp alltraps
80105e53:	e9 4f f9 ff ff       	jmp    801057a7 <alltraps>

80105e58 <vector57>:
.globl vector57
vector57:
  pushl $0
80105e58:	6a 00                	push   $0x0
  pushl $57
80105e5a:	6a 39                	push   $0x39
  jmp alltraps
80105e5c:	e9 46 f9 ff ff       	jmp    801057a7 <alltraps>

80105e61 <vector58>:
.globl vector58
vector58:
  pushl $0
80105e61:	6a 00                	push   $0x0
  pushl $58
80105e63:	6a 3a                	push   $0x3a
  jmp alltraps
80105e65:	e9 3d f9 ff ff       	jmp    801057a7 <alltraps>

80105e6a <vector59>:
.globl vector59
vector59:
  pushl $0
80105e6a:	6a 00                	push   $0x0
  pushl $59
80105e6c:	6a 3b                	push   $0x3b
  jmp alltraps
80105e6e:	e9 34 f9 ff ff       	jmp    801057a7 <alltraps>

80105e73 <vector60>:
.globl vector60
vector60:
  pushl $0
80105e73:	6a 00                	push   $0x0
  pushl $60
80105e75:	6a 3c                	push   $0x3c
  jmp alltraps
80105e77:	e9 2b f9 ff ff       	jmp    801057a7 <alltraps>

80105e7c <vector61>:
.globl vector61
vector61:
  pushl $0
80105e7c:	6a 00                	push   $0x0
  pushl $61
80105e7e:	6a 3d                	push   $0x3d
  jmp alltraps
80105e80:	e9 22 f9 ff ff       	jmp    801057a7 <alltraps>

80105e85 <vector62>:
.globl vector62
vector62:
  pushl $0
80105e85:	6a 00                	push   $0x0
  pushl $62
80105e87:	6a 3e                	push   $0x3e
  jmp alltraps
80105e89:	e9 19 f9 ff ff       	jmp    801057a7 <alltraps>

80105e8e <vector63>:
.globl vector63
vector63:
  pushl $0
80105e8e:	6a 00                	push   $0x0
  pushl $63
80105e90:	6a 3f                	push   $0x3f
  jmp alltraps
80105e92:	e9 10 f9 ff ff       	jmp    801057a7 <alltraps>

80105e97 <vector64>:
.globl vector64
vector64:
  pushl $0
80105e97:	6a 00                	push   $0x0
  pushl $64
80105e99:	6a 40                	push   $0x40
  jmp alltraps
80105e9b:	e9 07 f9 ff ff       	jmp    801057a7 <alltraps>

80105ea0 <vector65>:
.globl vector65
vector65:
  pushl $0
80105ea0:	6a 00                	push   $0x0
  pushl $65
80105ea2:	6a 41                	push   $0x41
  jmp alltraps
80105ea4:	e9 fe f8 ff ff       	jmp    801057a7 <alltraps>

80105ea9 <vector66>:
.globl vector66
vector66:
  pushl $0
80105ea9:	6a 00                	push   $0x0
  pushl $66
80105eab:	6a 42                	push   $0x42
  jmp alltraps
80105ead:	e9 f5 f8 ff ff       	jmp    801057a7 <alltraps>

80105eb2 <vector67>:
.globl vector67
vector67:
  pushl $0
80105eb2:	6a 00                	push   $0x0
  pushl $67
80105eb4:	6a 43                	push   $0x43
  jmp alltraps
80105eb6:	e9 ec f8 ff ff       	jmp    801057a7 <alltraps>

80105ebb <vector68>:
.globl vector68
vector68:
  pushl $0
80105ebb:	6a 00                	push   $0x0
  pushl $68
80105ebd:	6a 44                	push   $0x44
  jmp alltraps
80105ebf:	e9 e3 f8 ff ff       	jmp    801057a7 <alltraps>

80105ec4 <vector69>:
.globl vector69
vector69:
  pushl $0
80105ec4:	6a 00                	push   $0x0
  pushl $69
80105ec6:	6a 45                	push   $0x45
  jmp alltraps
80105ec8:	e9 da f8 ff ff       	jmp    801057a7 <alltraps>

80105ecd <vector70>:
.globl vector70
vector70:
  pushl $0
80105ecd:	6a 00                	push   $0x0
  pushl $70
80105ecf:	6a 46                	push   $0x46
  jmp alltraps
80105ed1:	e9 d1 f8 ff ff       	jmp    801057a7 <alltraps>

80105ed6 <vector71>:
.globl vector71
vector71:
  pushl $0
80105ed6:	6a 00                	push   $0x0
  pushl $71
80105ed8:	6a 47                	push   $0x47
  jmp alltraps
80105eda:	e9 c8 f8 ff ff       	jmp    801057a7 <alltraps>

80105edf <vector72>:
.globl vector72
vector72:
  pushl $0
80105edf:	6a 00                	push   $0x0
  pushl $72
80105ee1:	6a 48                	push   $0x48
  jmp alltraps
80105ee3:	e9 bf f8 ff ff       	jmp    801057a7 <alltraps>

80105ee8 <vector73>:
.globl vector73
vector73:
  pushl $0
80105ee8:	6a 00                	push   $0x0
  pushl $73
80105eea:	6a 49                	push   $0x49
  jmp alltraps
80105eec:	e9 b6 f8 ff ff       	jmp    801057a7 <alltraps>

80105ef1 <vector74>:
.globl vector74
vector74:
  pushl $0
80105ef1:	6a 00                	push   $0x0
  pushl $74
80105ef3:	6a 4a                	push   $0x4a
  jmp alltraps
80105ef5:	e9 ad f8 ff ff       	jmp    801057a7 <alltraps>

80105efa <vector75>:
.globl vector75
vector75:
  pushl $0
80105efa:	6a 00                	push   $0x0
  pushl $75
80105efc:	6a 4b                	push   $0x4b
  jmp alltraps
80105efe:	e9 a4 f8 ff ff       	jmp    801057a7 <alltraps>

80105f03 <vector76>:
.globl vector76
vector76:
  pushl $0
80105f03:	6a 00                	push   $0x0
  pushl $76
80105f05:	6a 4c                	push   $0x4c
  jmp alltraps
80105f07:	e9 9b f8 ff ff       	jmp    801057a7 <alltraps>

80105f0c <vector77>:
.globl vector77
vector77:
  pushl $0
80105f0c:	6a 00                	push   $0x0
  pushl $77
80105f0e:	6a 4d                	push   $0x4d
  jmp alltraps
80105f10:	e9 92 f8 ff ff       	jmp    801057a7 <alltraps>

80105f15 <vector78>:
.globl vector78
vector78:
  pushl $0
80105f15:	6a 00                	push   $0x0
  pushl $78
80105f17:	6a 4e                	push   $0x4e
  jmp alltraps
80105f19:	e9 89 f8 ff ff       	jmp    801057a7 <alltraps>

80105f1e <vector79>:
.globl vector79
vector79:
  pushl $0
80105f1e:	6a 00                	push   $0x0
  pushl $79
80105f20:	6a 4f                	push   $0x4f
  jmp alltraps
80105f22:	e9 80 f8 ff ff       	jmp    801057a7 <alltraps>

80105f27 <vector80>:
.globl vector80
vector80:
  pushl $0
80105f27:	6a 00                	push   $0x0
  pushl $80
80105f29:	6a 50                	push   $0x50
  jmp alltraps
80105f2b:	e9 77 f8 ff ff       	jmp    801057a7 <alltraps>

80105f30 <vector81>:
.globl vector81
vector81:
  pushl $0
80105f30:	6a 00                	push   $0x0
  pushl $81
80105f32:	6a 51                	push   $0x51
  jmp alltraps
80105f34:	e9 6e f8 ff ff       	jmp    801057a7 <alltraps>

80105f39 <vector82>:
.globl vector82
vector82:
  pushl $0
80105f39:	6a 00                	push   $0x0
  pushl $82
80105f3b:	6a 52                	push   $0x52
  jmp alltraps
80105f3d:	e9 65 f8 ff ff       	jmp    801057a7 <alltraps>

80105f42 <vector83>:
.globl vector83
vector83:
  pushl $0
80105f42:	6a 00                	push   $0x0
  pushl $83
80105f44:	6a 53                	push   $0x53
  jmp alltraps
80105f46:	e9 5c f8 ff ff       	jmp    801057a7 <alltraps>

80105f4b <vector84>:
.globl vector84
vector84:
  pushl $0
80105f4b:	6a 00                	push   $0x0
  pushl $84
80105f4d:	6a 54                	push   $0x54
  jmp alltraps
80105f4f:	e9 53 f8 ff ff       	jmp    801057a7 <alltraps>

80105f54 <vector85>:
.globl vector85
vector85:
  pushl $0
80105f54:	6a 00                	push   $0x0
  pushl $85
80105f56:	6a 55                	push   $0x55
  jmp alltraps
80105f58:	e9 4a f8 ff ff       	jmp    801057a7 <alltraps>

80105f5d <vector86>:
.globl vector86
vector86:
  pushl $0
80105f5d:	6a 00                	push   $0x0
  pushl $86
80105f5f:	6a 56                	push   $0x56
  jmp alltraps
80105f61:	e9 41 f8 ff ff       	jmp    801057a7 <alltraps>

80105f66 <vector87>:
.globl vector87
vector87:
  pushl $0
80105f66:	6a 00                	push   $0x0
  pushl $87
80105f68:	6a 57                	push   $0x57
  jmp alltraps
80105f6a:	e9 38 f8 ff ff       	jmp    801057a7 <alltraps>

80105f6f <vector88>:
.globl vector88
vector88:
  pushl $0
80105f6f:	6a 00                	push   $0x0
  pushl $88
80105f71:	6a 58                	push   $0x58
  jmp alltraps
80105f73:	e9 2f f8 ff ff       	jmp    801057a7 <alltraps>

80105f78 <vector89>:
.globl vector89
vector89:
  pushl $0
80105f78:	6a 00                	push   $0x0
  pushl $89
80105f7a:	6a 59                	push   $0x59
  jmp alltraps
80105f7c:	e9 26 f8 ff ff       	jmp    801057a7 <alltraps>

80105f81 <vector90>:
.globl vector90
vector90:
  pushl $0
80105f81:	6a 00                	push   $0x0
  pushl $90
80105f83:	6a 5a                	push   $0x5a
  jmp alltraps
80105f85:	e9 1d f8 ff ff       	jmp    801057a7 <alltraps>

80105f8a <vector91>:
.globl vector91
vector91:
  pushl $0
80105f8a:	6a 00                	push   $0x0
  pushl $91
80105f8c:	6a 5b                	push   $0x5b
  jmp alltraps
80105f8e:	e9 14 f8 ff ff       	jmp    801057a7 <alltraps>

80105f93 <vector92>:
.globl vector92
vector92:
  pushl $0
80105f93:	6a 00                	push   $0x0
  pushl $92
80105f95:	6a 5c                	push   $0x5c
  jmp alltraps
80105f97:	e9 0b f8 ff ff       	jmp    801057a7 <alltraps>

80105f9c <vector93>:
.globl vector93
vector93:
  pushl $0
80105f9c:	6a 00                	push   $0x0
  pushl $93
80105f9e:	6a 5d                	push   $0x5d
  jmp alltraps
80105fa0:	e9 02 f8 ff ff       	jmp    801057a7 <alltraps>

80105fa5 <vector94>:
.globl vector94
vector94:
  pushl $0
80105fa5:	6a 00                	push   $0x0
  pushl $94
80105fa7:	6a 5e                	push   $0x5e
  jmp alltraps
80105fa9:	e9 f9 f7 ff ff       	jmp    801057a7 <alltraps>

80105fae <vector95>:
.globl vector95
vector95:
  pushl $0
80105fae:	6a 00                	push   $0x0
  pushl $95
80105fb0:	6a 5f                	push   $0x5f
  jmp alltraps
80105fb2:	e9 f0 f7 ff ff       	jmp    801057a7 <alltraps>

80105fb7 <vector96>:
.globl vector96
vector96:
  pushl $0
80105fb7:	6a 00                	push   $0x0
  pushl $96
80105fb9:	6a 60                	push   $0x60
  jmp alltraps
80105fbb:	e9 e7 f7 ff ff       	jmp    801057a7 <alltraps>

80105fc0 <vector97>:
.globl vector97
vector97:
  pushl $0
80105fc0:	6a 00                	push   $0x0
  pushl $97
80105fc2:	6a 61                	push   $0x61
  jmp alltraps
80105fc4:	e9 de f7 ff ff       	jmp    801057a7 <alltraps>

80105fc9 <vector98>:
.globl vector98
vector98:
  pushl $0
80105fc9:	6a 00                	push   $0x0
  pushl $98
80105fcb:	6a 62                	push   $0x62
  jmp alltraps
80105fcd:	e9 d5 f7 ff ff       	jmp    801057a7 <alltraps>

80105fd2 <vector99>:
.globl vector99
vector99:
  pushl $0
80105fd2:	6a 00                	push   $0x0
  pushl $99
80105fd4:	6a 63                	push   $0x63
  jmp alltraps
80105fd6:	e9 cc f7 ff ff       	jmp    801057a7 <alltraps>

80105fdb <vector100>:
.globl vector100
vector100:
  pushl $0
80105fdb:	6a 00                	push   $0x0
  pushl $100
80105fdd:	6a 64                	push   $0x64
  jmp alltraps
80105fdf:	e9 c3 f7 ff ff       	jmp    801057a7 <alltraps>

80105fe4 <vector101>:
.globl vector101
vector101:
  pushl $0
80105fe4:	6a 00                	push   $0x0
  pushl $101
80105fe6:	6a 65                	push   $0x65
  jmp alltraps
80105fe8:	e9 ba f7 ff ff       	jmp    801057a7 <alltraps>

80105fed <vector102>:
.globl vector102
vector102:
  pushl $0
80105fed:	6a 00                	push   $0x0
  pushl $102
80105fef:	6a 66                	push   $0x66
  jmp alltraps
80105ff1:	e9 b1 f7 ff ff       	jmp    801057a7 <alltraps>

80105ff6 <vector103>:
.globl vector103
vector103:
  pushl $0
80105ff6:	6a 00                	push   $0x0
  pushl $103
80105ff8:	6a 67                	push   $0x67
  jmp alltraps
80105ffa:	e9 a8 f7 ff ff       	jmp    801057a7 <alltraps>

80105fff <vector104>:
.globl vector104
vector104:
  pushl $0
80105fff:	6a 00                	push   $0x0
  pushl $104
80106001:	6a 68                	push   $0x68
  jmp alltraps
80106003:	e9 9f f7 ff ff       	jmp    801057a7 <alltraps>

80106008 <vector105>:
.globl vector105
vector105:
  pushl $0
80106008:	6a 00                	push   $0x0
  pushl $105
8010600a:	6a 69                	push   $0x69
  jmp alltraps
8010600c:	e9 96 f7 ff ff       	jmp    801057a7 <alltraps>

80106011 <vector106>:
.globl vector106
vector106:
  pushl $0
80106011:	6a 00                	push   $0x0
  pushl $106
80106013:	6a 6a                	push   $0x6a
  jmp alltraps
80106015:	e9 8d f7 ff ff       	jmp    801057a7 <alltraps>

8010601a <vector107>:
.globl vector107
vector107:
  pushl $0
8010601a:	6a 00                	push   $0x0
  pushl $107
8010601c:	6a 6b                	push   $0x6b
  jmp alltraps
8010601e:	e9 84 f7 ff ff       	jmp    801057a7 <alltraps>

80106023 <vector108>:
.globl vector108
vector108:
  pushl $0
80106023:	6a 00                	push   $0x0
  pushl $108
80106025:	6a 6c                	push   $0x6c
  jmp alltraps
80106027:	e9 7b f7 ff ff       	jmp    801057a7 <alltraps>

8010602c <vector109>:
.globl vector109
vector109:
  pushl $0
8010602c:	6a 00                	push   $0x0
  pushl $109
8010602e:	6a 6d                	push   $0x6d
  jmp alltraps
80106030:	e9 72 f7 ff ff       	jmp    801057a7 <alltraps>

80106035 <vector110>:
.globl vector110
vector110:
  pushl $0
80106035:	6a 00                	push   $0x0
  pushl $110
80106037:	6a 6e                	push   $0x6e
  jmp alltraps
80106039:	e9 69 f7 ff ff       	jmp    801057a7 <alltraps>

8010603e <vector111>:
.globl vector111
vector111:
  pushl $0
8010603e:	6a 00                	push   $0x0
  pushl $111
80106040:	6a 6f                	push   $0x6f
  jmp alltraps
80106042:	e9 60 f7 ff ff       	jmp    801057a7 <alltraps>

80106047 <vector112>:
.globl vector112
vector112:
  pushl $0
80106047:	6a 00                	push   $0x0
  pushl $112
80106049:	6a 70                	push   $0x70
  jmp alltraps
8010604b:	e9 57 f7 ff ff       	jmp    801057a7 <alltraps>

80106050 <vector113>:
.globl vector113
vector113:
  pushl $0
80106050:	6a 00                	push   $0x0
  pushl $113
80106052:	6a 71                	push   $0x71
  jmp alltraps
80106054:	e9 4e f7 ff ff       	jmp    801057a7 <alltraps>

80106059 <vector114>:
.globl vector114
vector114:
  pushl $0
80106059:	6a 00                	push   $0x0
  pushl $114
8010605b:	6a 72                	push   $0x72
  jmp alltraps
8010605d:	e9 45 f7 ff ff       	jmp    801057a7 <alltraps>

80106062 <vector115>:
.globl vector115
vector115:
  pushl $0
80106062:	6a 00                	push   $0x0
  pushl $115
80106064:	6a 73                	push   $0x73
  jmp alltraps
80106066:	e9 3c f7 ff ff       	jmp    801057a7 <alltraps>

8010606b <vector116>:
.globl vector116
vector116:
  pushl $0
8010606b:	6a 00                	push   $0x0
  pushl $116
8010606d:	6a 74                	push   $0x74
  jmp alltraps
8010606f:	e9 33 f7 ff ff       	jmp    801057a7 <alltraps>

80106074 <vector117>:
.globl vector117
vector117:
  pushl $0
80106074:	6a 00                	push   $0x0
  pushl $117
80106076:	6a 75                	push   $0x75
  jmp alltraps
80106078:	e9 2a f7 ff ff       	jmp    801057a7 <alltraps>

8010607d <vector118>:
.globl vector118
vector118:
  pushl $0
8010607d:	6a 00                	push   $0x0
  pushl $118
8010607f:	6a 76                	push   $0x76
  jmp alltraps
80106081:	e9 21 f7 ff ff       	jmp    801057a7 <alltraps>

80106086 <vector119>:
.globl vector119
vector119:
  pushl $0
80106086:	6a 00                	push   $0x0
  pushl $119
80106088:	6a 77                	push   $0x77
  jmp alltraps
8010608a:	e9 18 f7 ff ff       	jmp    801057a7 <alltraps>

8010608f <vector120>:
.globl vector120
vector120:
  pushl $0
8010608f:	6a 00                	push   $0x0
  pushl $120
80106091:	6a 78                	push   $0x78
  jmp alltraps
80106093:	e9 0f f7 ff ff       	jmp    801057a7 <alltraps>

80106098 <vector121>:
.globl vector121
vector121:
  pushl $0
80106098:	6a 00                	push   $0x0
  pushl $121
8010609a:	6a 79                	push   $0x79
  jmp alltraps
8010609c:	e9 06 f7 ff ff       	jmp    801057a7 <alltraps>

801060a1 <vector122>:
.globl vector122
vector122:
  pushl $0
801060a1:	6a 00                	push   $0x0
  pushl $122
801060a3:	6a 7a                	push   $0x7a
  jmp alltraps
801060a5:	e9 fd f6 ff ff       	jmp    801057a7 <alltraps>

801060aa <vector123>:
.globl vector123
vector123:
  pushl $0
801060aa:	6a 00                	push   $0x0
  pushl $123
801060ac:	6a 7b                	push   $0x7b
  jmp alltraps
801060ae:	e9 f4 f6 ff ff       	jmp    801057a7 <alltraps>

801060b3 <vector124>:
.globl vector124
vector124:
  pushl $0
801060b3:	6a 00                	push   $0x0
  pushl $124
801060b5:	6a 7c                	push   $0x7c
  jmp alltraps
801060b7:	e9 eb f6 ff ff       	jmp    801057a7 <alltraps>

801060bc <vector125>:
.globl vector125
vector125:
  pushl $0
801060bc:	6a 00                	push   $0x0
  pushl $125
801060be:	6a 7d                	push   $0x7d
  jmp alltraps
801060c0:	e9 e2 f6 ff ff       	jmp    801057a7 <alltraps>

801060c5 <vector126>:
.globl vector126
vector126:
  pushl $0
801060c5:	6a 00                	push   $0x0
  pushl $126
801060c7:	6a 7e                	push   $0x7e
  jmp alltraps
801060c9:	e9 d9 f6 ff ff       	jmp    801057a7 <alltraps>

801060ce <vector127>:
.globl vector127
vector127:
  pushl $0
801060ce:	6a 00                	push   $0x0
  pushl $127
801060d0:	6a 7f                	push   $0x7f
  jmp alltraps
801060d2:	e9 d0 f6 ff ff       	jmp    801057a7 <alltraps>

801060d7 <vector128>:
.globl vector128
vector128:
  pushl $0
801060d7:	6a 00                	push   $0x0
  pushl $128
801060d9:	68 80 00 00 00       	push   $0x80
  jmp alltraps
801060de:	e9 c4 f6 ff ff       	jmp    801057a7 <alltraps>

801060e3 <vector129>:
.globl vector129
vector129:
  pushl $0
801060e3:	6a 00                	push   $0x0
  pushl $129
801060e5:	68 81 00 00 00       	push   $0x81
  jmp alltraps
801060ea:	e9 b8 f6 ff ff       	jmp    801057a7 <alltraps>

801060ef <vector130>:
.globl vector130
vector130:
  pushl $0
801060ef:	6a 00                	push   $0x0
  pushl $130
801060f1:	68 82 00 00 00       	push   $0x82
  jmp alltraps
801060f6:	e9 ac f6 ff ff       	jmp    801057a7 <alltraps>

801060fb <vector131>:
.globl vector131
vector131:
  pushl $0
801060fb:	6a 00                	push   $0x0
  pushl $131
801060fd:	68 83 00 00 00       	push   $0x83
  jmp alltraps
80106102:	e9 a0 f6 ff ff       	jmp    801057a7 <alltraps>

80106107 <vector132>:
.globl vector132
vector132:
  pushl $0
80106107:	6a 00                	push   $0x0
  pushl $132
80106109:	68 84 00 00 00       	push   $0x84
  jmp alltraps
8010610e:	e9 94 f6 ff ff       	jmp    801057a7 <alltraps>

80106113 <vector133>:
.globl vector133
vector133:
  pushl $0
80106113:	6a 00                	push   $0x0
  pushl $133
80106115:	68 85 00 00 00       	push   $0x85
  jmp alltraps
8010611a:	e9 88 f6 ff ff       	jmp    801057a7 <alltraps>

8010611f <vector134>:
.globl vector134
vector134:
  pushl $0
8010611f:	6a 00                	push   $0x0
  pushl $134
80106121:	68 86 00 00 00       	push   $0x86
  jmp alltraps
80106126:	e9 7c f6 ff ff       	jmp    801057a7 <alltraps>

8010612b <vector135>:
.globl vector135
vector135:
  pushl $0
8010612b:	6a 00                	push   $0x0
  pushl $135
8010612d:	68 87 00 00 00       	push   $0x87
  jmp alltraps
80106132:	e9 70 f6 ff ff       	jmp    801057a7 <alltraps>

80106137 <vector136>:
.globl vector136
vector136:
  pushl $0
80106137:	6a 00                	push   $0x0
  pushl $136
80106139:	68 88 00 00 00       	push   $0x88
  jmp alltraps
8010613e:	e9 64 f6 ff ff       	jmp    801057a7 <alltraps>

80106143 <vector137>:
.globl vector137
vector137:
  pushl $0
80106143:	6a 00                	push   $0x0
  pushl $137
80106145:	68 89 00 00 00       	push   $0x89
  jmp alltraps
8010614a:	e9 58 f6 ff ff       	jmp    801057a7 <alltraps>

8010614f <vector138>:
.globl vector138
vector138:
  pushl $0
8010614f:	6a 00                	push   $0x0
  pushl $138
80106151:	68 8a 00 00 00       	push   $0x8a
  jmp alltraps
80106156:	e9 4c f6 ff ff       	jmp    801057a7 <alltraps>

8010615b <vector139>:
.globl vector139
vector139:
  pushl $0
8010615b:	6a 00                	push   $0x0
  pushl $139
8010615d:	68 8b 00 00 00       	push   $0x8b
  jmp alltraps
80106162:	e9 40 f6 ff ff       	jmp    801057a7 <alltraps>

80106167 <vector140>:
.globl vector140
vector140:
  pushl $0
80106167:	6a 00                	push   $0x0
  pushl $140
80106169:	68 8c 00 00 00       	push   $0x8c
  jmp alltraps
8010616e:	e9 34 f6 ff ff       	jmp    801057a7 <alltraps>

80106173 <vector141>:
.globl vector141
vector141:
  pushl $0
80106173:	6a 00                	push   $0x0
  pushl $141
80106175:	68 8d 00 00 00       	push   $0x8d
  jmp alltraps
8010617a:	e9 28 f6 ff ff       	jmp    801057a7 <alltraps>

8010617f <vector142>:
.globl vector142
vector142:
  pushl $0
8010617f:	6a 00                	push   $0x0
  pushl $142
80106181:	68 8e 00 00 00       	push   $0x8e
  jmp alltraps
80106186:	e9 1c f6 ff ff       	jmp    801057a7 <alltraps>

8010618b <vector143>:
.globl vector143
vector143:
  pushl $0
8010618b:	6a 00                	push   $0x0
  pushl $143
8010618d:	68 8f 00 00 00       	push   $0x8f
  jmp alltraps
80106192:	e9 10 f6 ff ff       	jmp    801057a7 <alltraps>

80106197 <vector144>:
.globl vector144
vector144:
  pushl $0
80106197:	6a 00                	push   $0x0
  pushl $144
80106199:	68 90 00 00 00       	push   $0x90
  jmp alltraps
8010619e:	e9 04 f6 ff ff       	jmp    801057a7 <alltraps>

801061a3 <vector145>:
.globl vector145
vector145:
  pushl $0
801061a3:	6a 00                	push   $0x0
  pushl $145
801061a5:	68 91 00 00 00       	push   $0x91
  jmp alltraps
801061aa:	e9 f8 f5 ff ff       	jmp    801057a7 <alltraps>

801061af <vector146>:
.globl vector146
vector146:
  pushl $0
801061af:	6a 00                	push   $0x0
  pushl $146
801061b1:	68 92 00 00 00       	push   $0x92
  jmp alltraps
801061b6:	e9 ec f5 ff ff       	jmp    801057a7 <alltraps>

801061bb <vector147>:
.globl vector147
vector147:
  pushl $0
801061bb:	6a 00                	push   $0x0
  pushl $147
801061bd:	68 93 00 00 00       	push   $0x93
  jmp alltraps
801061c2:	e9 e0 f5 ff ff       	jmp    801057a7 <alltraps>

801061c7 <vector148>:
.globl vector148
vector148:
  pushl $0
801061c7:	6a 00                	push   $0x0
  pushl $148
801061c9:	68 94 00 00 00       	push   $0x94
  jmp alltraps
801061ce:	e9 d4 f5 ff ff       	jmp    801057a7 <alltraps>

801061d3 <vector149>:
.globl vector149
vector149:
  pushl $0
801061d3:	6a 00                	push   $0x0
  pushl $149
801061d5:	68 95 00 00 00       	push   $0x95
  jmp alltraps
801061da:	e9 c8 f5 ff ff       	jmp    801057a7 <alltraps>

801061df <vector150>:
.globl vector150
vector150:
  pushl $0
801061df:	6a 00                	push   $0x0
  pushl $150
801061e1:	68 96 00 00 00       	push   $0x96
  jmp alltraps
801061e6:	e9 bc f5 ff ff       	jmp    801057a7 <alltraps>

801061eb <vector151>:
.globl vector151
vector151:
  pushl $0
801061eb:	6a 00                	push   $0x0
  pushl $151
801061ed:	68 97 00 00 00       	push   $0x97
  jmp alltraps
801061f2:	e9 b0 f5 ff ff       	jmp    801057a7 <alltraps>

801061f7 <vector152>:
.globl vector152
vector152:
  pushl $0
801061f7:	6a 00                	push   $0x0
  pushl $152
801061f9:	68 98 00 00 00       	push   $0x98
  jmp alltraps
801061fe:	e9 a4 f5 ff ff       	jmp    801057a7 <alltraps>

80106203 <vector153>:
.globl vector153
vector153:
  pushl $0
80106203:	6a 00                	push   $0x0
  pushl $153
80106205:	68 99 00 00 00       	push   $0x99
  jmp alltraps
8010620a:	e9 98 f5 ff ff       	jmp    801057a7 <alltraps>

8010620f <vector154>:
.globl vector154
vector154:
  pushl $0
8010620f:	6a 00                	push   $0x0
  pushl $154
80106211:	68 9a 00 00 00       	push   $0x9a
  jmp alltraps
80106216:	e9 8c f5 ff ff       	jmp    801057a7 <alltraps>

8010621b <vector155>:
.globl vector155
vector155:
  pushl $0
8010621b:	6a 00                	push   $0x0
  pushl $155
8010621d:	68 9b 00 00 00       	push   $0x9b
  jmp alltraps
80106222:	e9 80 f5 ff ff       	jmp    801057a7 <alltraps>

80106227 <vector156>:
.globl vector156
vector156:
  pushl $0
80106227:	6a 00                	push   $0x0
  pushl $156
80106229:	68 9c 00 00 00       	push   $0x9c
  jmp alltraps
8010622e:	e9 74 f5 ff ff       	jmp    801057a7 <alltraps>

80106233 <vector157>:
.globl vector157
vector157:
  pushl $0
80106233:	6a 00                	push   $0x0
  pushl $157
80106235:	68 9d 00 00 00       	push   $0x9d
  jmp alltraps
8010623a:	e9 68 f5 ff ff       	jmp    801057a7 <alltraps>

8010623f <vector158>:
.globl vector158
vector158:
  pushl $0
8010623f:	6a 00                	push   $0x0
  pushl $158
80106241:	68 9e 00 00 00       	push   $0x9e
  jmp alltraps
80106246:	e9 5c f5 ff ff       	jmp    801057a7 <alltraps>

8010624b <vector159>:
.globl vector159
vector159:
  pushl $0
8010624b:	6a 00                	push   $0x0
  pushl $159
8010624d:	68 9f 00 00 00       	push   $0x9f
  jmp alltraps
80106252:	e9 50 f5 ff ff       	jmp    801057a7 <alltraps>

80106257 <vector160>:
.globl vector160
vector160:
  pushl $0
80106257:	6a 00                	push   $0x0
  pushl $160
80106259:	68 a0 00 00 00       	push   $0xa0
  jmp alltraps
8010625e:	e9 44 f5 ff ff       	jmp    801057a7 <alltraps>

80106263 <vector161>:
.globl vector161
vector161:
  pushl $0
80106263:	6a 00                	push   $0x0
  pushl $161
80106265:	68 a1 00 00 00       	push   $0xa1
  jmp alltraps
8010626a:	e9 38 f5 ff ff       	jmp    801057a7 <alltraps>

8010626f <vector162>:
.globl vector162
vector162:
  pushl $0
8010626f:	6a 00                	push   $0x0
  pushl $162
80106271:	68 a2 00 00 00       	push   $0xa2
  jmp alltraps
80106276:	e9 2c f5 ff ff       	jmp    801057a7 <alltraps>

8010627b <vector163>:
.globl vector163
vector163:
  pushl $0
8010627b:	6a 00                	push   $0x0
  pushl $163
8010627d:	68 a3 00 00 00       	push   $0xa3
  jmp alltraps
80106282:	e9 20 f5 ff ff       	jmp    801057a7 <alltraps>

80106287 <vector164>:
.globl vector164
vector164:
  pushl $0
80106287:	6a 00                	push   $0x0
  pushl $164
80106289:	68 a4 00 00 00       	push   $0xa4
  jmp alltraps
8010628e:	e9 14 f5 ff ff       	jmp    801057a7 <alltraps>

80106293 <vector165>:
.globl vector165
vector165:
  pushl $0
80106293:	6a 00                	push   $0x0
  pushl $165
80106295:	68 a5 00 00 00       	push   $0xa5
  jmp alltraps
8010629a:	e9 08 f5 ff ff       	jmp    801057a7 <alltraps>

8010629f <vector166>:
.globl vector166
vector166:
  pushl $0
8010629f:	6a 00                	push   $0x0
  pushl $166
801062a1:	68 a6 00 00 00       	push   $0xa6
  jmp alltraps
801062a6:	e9 fc f4 ff ff       	jmp    801057a7 <alltraps>

801062ab <vector167>:
.globl vector167
vector167:
  pushl $0
801062ab:	6a 00                	push   $0x0
  pushl $167
801062ad:	68 a7 00 00 00       	push   $0xa7
  jmp alltraps
801062b2:	e9 f0 f4 ff ff       	jmp    801057a7 <alltraps>

801062b7 <vector168>:
.globl vector168
vector168:
  pushl $0
801062b7:	6a 00                	push   $0x0
  pushl $168
801062b9:	68 a8 00 00 00       	push   $0xa8
  jmp alltraps
801062be:	e9 e4 f4 ff ff       	jmp    801057a7 <alltraps>

801062c3 <vector169>:
.globl vector169
vector169:
  pushl $0
801062c3:	6a 00                	push   $0x0
  pushl $169
801062c5:	68 a9 00 00 00       	push   $0xa9
  jmp alltraps
801062ca:	e9 d8 f4 ff ff       	jmp    801057a7 <alltraps>

801062cf <vector170>:
.globl vector170
vector170:
  pushl $0
801062cf:	6a 00                	push   $0x0
  pushl $170
801062d1:	68 aa 00 00 00       	push   $0xaa
  jmp alltraps
801062d6:	e9 cc f4 ff ff       	jmp    801057a7 <alltraps>

801062db <vector171>:
.globl vector171
vector171:
  pushl $0
801062db:	6a 00                	push   $0x0
  pushl $171
801062dd:	68 ab 00 00 00       	push   $0xab
  jmp alltraps
801062e2:	e9 c0 f4 ff ff       	jmp    801057a7 <alltraps>

801062e7 <vector172>:
.globl vector172
vector172:
  pushl $0
801062e7:	6a 00                	push   $0x0
  pushl $172
801062e9:	68 ac 00 00 00       	push   $0xac
  jmp alltraps
801062ee:	e9 b4 f4 ff ff       	jmp    801057a7 <alltraps>

801062f3 <vector173>:
.globl vector173
vector173:
  pushl $0
801062f3:	6a 00                	push   $0x0
  pushl $173
801062f5:	68 ad 00 00 00       	push   $0xad
  jmp alltraps
801062fa:	e9 a8 f4 ff ff       	jmp    801057a7 <alltraps>

801062ff <vector174>:
.globl vector174
vector174:
  pushl $0
801062ff:	6a 00                	push   $0x0
  pushl $174
80106301:	68 ae 00 00 00       	push   $0xae
  jmp alltraps
80106306:	e9 9c f4 ff ff       	jmp    801057a7 <alltraps>

8010630b <vector175>:
.globl vector175
vector175:
  pushl $0
8010630b:	6a 00                	push   $0x0
  pushl $175
8010630d:	68 af 00 00 00       	push   $0xaf
  jmp alltraps
80106312:	e9 90 f4 ff ff       	jmp    801057a7 <alltraps>

80106317 <vector176>:
.globl vector176
vector176:
  pushl $0
80106317:	6a 00                	push   $0x0
  pushl $176
80106319:	68 b0 00 00 00       	push   $0xb0
  jmp alltraps
8010631e:	e9 84 f4 ff ff       	jmp    801057a7 <alltraps>

80106323 <vector177>:
.globl vector177
vector177:
  pushl $0
80106323:	6a 00                	push   $0x0
  pushl $177
80106325:	68 b1 00 00 00       	push   $0xb1
  jmp alltraps
8010632a:	e9 78 f4 ff ff       	jmp    801057a7 <alltraps>

8010632f <vector178>:
.globl vector178
vector178:
  pushl $0
8010632f:	6a 00                	push   $0x0
  pushl $178
80106331:	68 b2 00 00 00       	push   $0xb2
  jmp alltraps
80106336:	e9 6c f4 ff ff       	jmp    801057a7 <alltraps>

8010633b <vector179>:
.globl vector179
vector179:
  pushl $0
8010633b:	6a 00                	push   $0x0
  pushl $179
8010633d:	68 b3 00 00 00       	push   $0xb3
  jmp alltraps
80106342:	e9 60 f4 ff ff       	jmp    801057a7 <alltraps>

80106347 <vector180>:
.globl vector180
vector180:
  pushl $0
80106347:	6a 00                	push   $0x0
  pushl $180
80106349:	68 b4 00 00 00       	push   $0xb4
  jmp alltraps
8010634e:	e9 54 f4 ff ff       	jmp    801057a7 <alltraps>

80106353 <vector181>:
.globl vector181
vector181:
  pushl $0
80106353:	6a 00                	push   $0x0
  pushl $181
80106355:	68 b5 00 00 00       	push   $0xb5
  jmp alltraps
8010635a:	e9 48 f4 ff ff       	jmp    801057a7 <alltraps>

8010635f <vector182>:
.globl vector182
vector182:
  pushl $0
8010635f:	6a 00                	push   $0x0
  pushl $182
80106361:	68 b6 00 00 00       	push   $0xb6
  jmp alltraps
80106366:	e9 3c f4 ff ff       	jmp    801057a7 <alltraps>

8010636b <vector183>:
.globl vector183
vector183:
  pushl $0
8010636b:	6a 00                	push   $0x0
  pushl $183
8010636d:	68 b7 00 00 00       	push   $0xb7
  jmp alltraps
80106372:	e9 30 f4 ff ff       	jmp    801057a7 <alltraps>

80106377 <vector184>:
.globl vector184
vector184:
  pushl $0
80106377:	6a 00                	push   $0x0
  pushl $184
80106379:	68 b8 00 00 00       	push   $0xb8
  jmp alltraps
8010637e:	e9 24 f4 ff ff       	jmp    801057a7 <alltraps>

80106383 <vector185>:
.globl vector185
vector185:
  pushl $0
80106383:	6a 00                	push   $0x0
  pushl $185
80106385:	68 b9 00 00 00       	push   $0xb9
  jmp alltraps
8010638a:	e9 18 f4 ff ff       	jmp    801057a7 <alltraps>

8010638f <vector186>:
.globl vector186
vector186:
  pushl $0
8010638f:	6a 00                	push   $0x0
  pushl $186
80106391:	68 ba 00 00 00       	push   $0xba
  jmp alltraps
80106396:	e9 0c f4 ff ff       	jmp    801057a7 <alltraps>

8010639b <vector187>:
.globl vector187
vector187:
  pushl $0
8010639b:	6a 00                	push   $0x0
  pushl $187
8010639d:	68 bb 00 00 00       	push   $0xbb
  jmp alltraps
801063a2:	e9 00 f4 ff ff       	jmp    801057a7 <alltraps>

801063a7 <vector188>:
.globl vector188
vector188:
  pushl $0
801063a7:	6a 00                	push   $0x0
  pushl $188
801063a9:	68 bc 00 00 00       	push   $0xbc
  jmp alltraps
801063ae:	e9 f4 f3 ff ff       	jmp    801057a7 <alltraps>

801063b3 <vector189>:
.globl vector189
vector189:
  pushl $0
801063b3:	6a 00                	push   $0x0
  pushl $189
801063b5:	68 bd 00 00 00       	push   $0xbd
  jmp alltraps
801063ba:	e9 e8 f3 ff ff       	jmp    801057a7 <alltraps>

801063bf <vector190>:
.globl vector190
vector190:
  pushl $0
801063bf:	6a 00                	push   $0x0
  pushl $190
801063c1:	68 be 00 00 00       	push   $0xbe
  jmp alltraps
801063c6:	e9 dc f3 ff ff       	jmp    801057a7 <alltraps>

801063cb <vector191>:
.globl vector191
vector191:
  pushl $0
801063cb:	6a 00                	push   $0x0
  pushl $191
801063cd:	68 bf 00 00 00       	push   $0xbf
  jmp alltraps
801063d2:	e9 d0 f3 ff ff       	jmp    801057a7 <alltraps>

801063d7 <vector192>:
.globl vector192
vector192:
  pushl $0
801063d7:	6a 00                	push   $0x0
  pushl $192
801063d9:	68 c0 00 00 00       	push   $0xc0
  jmp alltraps
801063de:	e9 c4 f3 ff ff       	jmp    801057a7 <alltraps>

801063e3 <vector193>:
.globl vector193
vector193:
  pushl $0
801063e3:	6a 00                	push   $0x0
  pushl $193
801063e5:	68 c1 00 00 00       	push   $0xc1
  jmp alltraps
801063ea:	e9 b8 f3 ff ff       	jmp    801057a7 <alltraps>

801063ef <vector194>:
.globl vector194
vector194:
  pushl $0
801063ef:	6a 00                	push   $0x0
  pushl $194
801063f1:	68 c2 00 00 00       	push   $0xc2
  jmp alltraps
801063f6:	e9 ac f3 ff ff       	jmp    801057a7 <alltraps>

801063fb <vector195>:
.globl vector195
vector195:
  pushl $0
801063fb:	6a 00                	push   $0x0
  pushl $195
801063fd:	68 c3 00 00 00       	push   $0xc3
  jmp alltraps
80106402:	e9 a0 f3 ff ff       	jmp    801057a7 <alltraps>

80106407 <vector196>:
.globl vector196
vector196:
  pushl $0
80106407:	6a 00                	push   $0x0
  pushl $196
80106409:	68 c4 00 00 00       	push   $0xc4
  jmp alltraps
8010640e:	e9 94 f3 ff ff       	jmp    801057a7 <alltraps>

80106413 <vector197>:
.globl vector197
vector197:
  pushl $0
80106413:	6a 00                	push   $0x0
  pushl $197
80106415:	68 c5 00 00 00       	push   $0xc5
  jmp alltraps
8010641a:	e9 88 f3 ff ff       	jmp    801057a7 <alltraps>

8010641f <vector198>:
.globl vector198
vector198:
  pushl $0
8010641f:	6a 00                	push   $0x0
  pushl $198
80106421:	68 c6 00 00 00       	push   $0xc6
  jmp alltraps
80106426:	e9 7c f3 ff ff       	jmp    801057a7 <alltraps>

8010642b <vector199>:
.globl vector199
vector199:
  pushl $0
8010642b:	6a 00                	push   $0x0
  pushl $199
8010642d:	68 c7 00 00 00       	push   $0xc7
  jmp alltraps
80106432:	e9 70 f3 ff ff       	jmp    801057a7 <alltraps>

80106437 <vector200>:
.globl vector200
vector200:
  pushl $0
80106437:	6a 00                	push   $0x0
  pushl $200
80106439:	68 c8 00 00 00       	push   $0xc8
  jmp alltraps
8010643e:	e9 64 f3 ff ff       	jmp    801057a7 <alltraps>

80106443 <vector201>:
.globl vector201
vector201:
  pushl $0
80106443:	6a 00                	push   $0x0
  pushl $201
80106445:	68 c9 00 00 00       	push   $0xc9
  jmp alltraps
8010644a:	e9 58 f3 ff ff       	jmp    801057a7 <alltraps>

8010644f <vector202>:
.globl vector202
vector202:
  pushl $0
8010644f:	6a 00                	push   $0x0
  pushl $202
80106451:	68 ca 00 00 00       	push   $0xca
  jmp alltraps
80106456:	e9 4c f3 ff ff       	jmp    801057a7 <alltraps>

8010645b <vector203>:
.globl vector203
vector203:
  pushl $0
8010645b:	6a 00                	push   $0x0
  pushl $203
8010645d:	68 cb 00 00 00       	push   $0xcb
  jmp alltraps
80106462:	e9 40 f3 ff ff       	jmp    801057a7 <alltraps>

80106467 <vector204>:
.globl vector204
vector204:
  pushl $0
80106467:	6a 00                	push   $0x0
  pushl $204
80106469:	68 cc 00 00 00       	push   $0xcc
  jmp alltraps
8010646e:	e9 34 f3 ff ff       	jmp    801057a7 <alltraps>

80106473 <vector205>:
.globl vector205
vector205:
  pushl $0
80106473:	6a 00                	push   $0x0
  pushl $205
80106475:	68 cd 00 00 00       	push   $0xcd
  jmp alltraps
8010647a:	e9 28 f3 ff ff       	jmp    801057a7 <alltraps>

8010647f <vector206>:
.globl vector206
vector206:
  pushl $0
8010647f:	6a 00                	push   $0x0
  pushl $206
80106481:	68 ce 00 00 00       	push   $0xce
  jmp alltraps
80106486:	e9 1c f3 ff ff       	jmp    801057a7 <alltraps>

8010648b <vector207>:
.globl vector207
vector207:
  pushl $0
8010648b:	6a 00                	push   $0x0
  pushl $207
8010648d:	68 cf 00 00 00       	push   $0xcf
  jmp alltraps
80106492:	e9 10 f3 ff ff       	jmp    801057a7 <alltraps>

80106497 <vector208>:
.globl vector208
vector208:
  pushl $0
80106497:	6a 00                	push   $0x0
  pushl $208
80106499:	68 d0 00 00 00       	push   $0xd0
  jmp alltraps
8010649e:	e9 04 f3 ff ff       	jmp    801057a7 <alltraps>

801064a3 <vector209>:
.globl vector209
vector209:
  pushl $0
801064a3:	6a 00                	push   $0x0
  pushl $209
801064a5:	68 d1 00 00 00       	push   $0xd1
  jmp alltraps
801064aa:	e9 f8 f2 ff ff       	jmp    801057a7 <alltraps>

801064af <vector210>:
.globl vector210
vector210:
  pushl $0
801064af:	6a 00                	push   $0x0
  pushl $210
801064b1:	68 d2 00 00 00       	push   $0xd2
  jmp alltraps
801064b6:	e9 ec f2 ff ff       	jmp    801057a7 <alltraps>

801064bb <vector211>:
.globl vector211
vector211:
  pushl $0
801064bb:	6a 00                	push   $0x0
  pushl $211
801064bd:	68 d3 00 00 00       	push   $0xd3
  jmp alltraps
801064c2:	e9 e0 f2 ff ff       	jmp    801057a7 <alltraps>

801064c7 <vector212>:
.globl vector212
vector212:
  pushl $0
801064c7:	6a 00                	push   $0x0
  pushl $212
801064c9:	68 d4 00 00 00       	push   $0xd4
  jmp alltraps
801064ce:	e9 d4 f2 ff ff       	jmp    801057a7 <alltraps>

801064d3 <vector213>:
.globl vector213
vector213:
  pushl $0
801064d3:	6a 00                	push   $0x0
  pushl $213
801064d5:	68 d5 00 00 00       	push   $0xd5
  jmp alltraps
801064da:	e9 c8 f2 ff ff       	jmp    801057a7 <alltraps>

801064df <vector214>:
.globl vector214
vector214:
  pushl $0
801064df:	6a 00                	push   $0x0
  pushl $214
801064e1:	68 d6 00 00 00       	push   $0xd6
  jmp alltraps
801064e6:	e9 bc f2 ff ff       	jmp    801057a7 <alltraps>

801064eb <vector215>:
.globl vector215
vector215:
  pushl $0
801064eb:	6a 00                	push   $0x0
  pushl $215
801064ed:	68 d7 00 00 00       	push   $0xd7
  jmp alltraps
801064f2:	e9 b0 f2 ff ff       	jmp    801057a7 <alltraps>

801064f7 <vector216>:
.globl vector216
vector216:
  pushl $0
801064f7:	6a 00                	push   $0x0
  pushl $216
801064f9:	68 d8 00 00 00       	push   $0xd8
  jmp alltraps
801064fe:	e9 a4 f2 ff ff       	jmp    801057a7 <alltraps>

80106503 <vector217>:
.globl vector217
vector217:
  pushl $0
80106503:	6a 00                	push   $0x0
  pushl $217
80106505:	68 d9 00 00 00       	push   $0xd9
  jmp alltraps
8010650a:	e9 98 f2 ff ff       	jmp    801057a7 <alltraps>

8010650f <vector218>:
.globl vector218
vector218:
  pushl $0
8010650f:	6a 00                	push   $0x0
  pushl $218
80106511:	68 da 00 00 00       	push   $0xda
  jmp alltraps
80106516:	e9 8c f2 ff ff       	jmp    801057a7 <alltraps>

8010651b <vector219>:
.globl vector219
vector219:
  pushl $0
8010651b:	6a 00                	push   $0x0
  pushl $219
8010651d:	68 db 00 00 00       	push   $0xdb
  jmp alltraps
80106522:	e9 80 f2 ff ff       	jmp    801057a7 <alltraps>

80106527 <vector220>:
.globl vector220
vector220:
  pushl $0
80106527:	6a 00                	push   $0x0
  pushl $220
80106529:	68 dc 00 00 00       	push   $0xdc
  jmp alltraps
8010652e:	e9 74 f2 ff ff       	jmp    801057a7 <alltraps>

80106533 <vector221>:
.globl vector221
vector221:
  pushl $0
80106533:	6a 00                	push   $0x0
  pushl $221
80106535:	68 dd 00 00 00       	push   $0xdd
  jmp alltraps
8010653a:	e9 68 f2 ff ff       	jmp    801057a7 <alltraps>

8010653f <vector222>:
.globl vector222
vector222:
  pushl $0
8010653f:	6a 00                	push   $0x0
  pushl $222
80106541:	68 de 00 00 00       	push   $0xde
  jmp alltraps
80106546:	e9 5c f2 ff ff       	jmp    801057a7 <alltraps>

8010654b <vector223>:
.globl vector223
vector223:
  pushl $0
8010654b:	6a 00                	push   $0x0
  pushl $223
8010654d:	68 df 00 00 00       	push   $0xdf
  jmp alltraps
80106552:	e9 50 f2 ff ff       	jmp    801057a7 <alltraps>

80106557 <vector224>:
.globl vector224
vector224:
  pushl $0
80106557:	6a 00                	push   $0x0
  pushl $224
80106559:	68 e0 00 00 00       	push   $0xe0
  jmp alltraps
8010655e:	e9 44 f2 ff ff       	jmp    801057a7 <alltraps>

80106563 <vector225>:
.globl vector225
vector225:
  pushl $0
80106563:	6a 00                	push   $0x0
  pushl $225
80106565:	68 e1 00 00 00       	push   $0xe1
  jmp alltraps
8010656a:	e9 38 f2 ff ff       	jmp    801057a7 <alltraps>

8010656f <vector226>:
.globl vector226
vector226:
  pushl $0
8010656f:	6a 00                	push   $0x0
  pushl $226
80106571:	68 e2 00 00 00       	push   $0xe2
  jmp alltraps
80106576:	e9 2c f2 ff ff       	jmp    801057a7 <alltraps>

8010657b <vector227>:
.globl vector227
vector227:
  pushl $0
8010657b:	6a 00                	push   $0x0
  pushl $227
8010657d:	68 e3 00 00 00       	push   $0xe3
  jmp alltraps
80106582:	e9 20 f2 ff ff       	jmp    801057a7 <alltraps>

80106587 <vector228>:
.globl vector228
vector228:
  pushl $0
80106587:	6a 00                	push   $0x0
  pushl $228
80106589:	68 e4 00 00 00       	push   $0xe4
  jmp alltraps
8010658e:	e9 14 f2 ff ff       	jmp    801057a7 <alltraps>

80106593 <vector229>:
.globl vector229
vector229:
  pushl $0
80106593:	6a 00                	push   $0x0
  pushl $229
80106595:	68 e5 00 00 00       	push   $0xe5
  jmp alltraps
8010659a:	e9 08 f2 ff ff       	jmp    801057a7 <alltraps>

8010659f <vector230>:
.globl vector230
vector230:
  pushl $0
8010659f:	6a 00                	push   $0x0
  pushl $230
801065a1:	68 e6 00 00 00       	push   $0xe6
  jmp alltraps
801065a6:	e9 fc f1 ff ff       	jmp    801057a7 <alltraps>

801065ab <vector231>:
.globl vector231
vector231:
  pushl $0
801065ab:	6a 00                	push   $0x0
  pushl $231
801065ad:	68 e7 00 00 00       	push   $0xe7
  jmp alltraps
801065b2:	e9 f0 f1 ff ff       	jmp    801057a7 <alltraps>

801065b7 <vector232>:
.globl vector232
vector232:
  pushl $0
801065b7:	6a 00                	push   $0x0
  pushl $232
801065b9:	68 e8 00 00 00       	push   $0xe8
  jmp alltraps
801065be:	e9 e4 f1 ff ff       	jmp    801057a7 <alltraps>

801065c3 <vector233>:
.globl vector233
vector233:
  pushl $0
801065c3:	6a 00                	push   $0x0
  pushl $233
801065c5:	68 e9 00 00 00       	push   $0xe9
  jmp alltraps
801065ca:	e9 d8 f1 ff ff       	jmp    801057a7 <alltraps>

801065cf <vector234>:
.globl vector234
vector234:
  pushl $0
801065cf:	6a 00                	push   $0x0
  pushl $234
801065d1:	68 ea 00 00 00       	push   $0xea
  jmp alltraps
801065d6:	e9 cc f1 ff ff       	jmp    801057a7 <alltraps>

801065db <vector235>:
.globl vector235
vector235:
  pushl $0
801065db:	6a 00                	push   $0x0
  pushl $235
801065dd:	68 eb 00 00 00       	push   $0xeb
  jmp alltraps
801065e2:	e9 c0 f1 ff ff       	jmp    801057a7 <alltraps>

801065e7 <vector236>:
.globl vector236
vector236:
  pushl $0
801065e7:	6a 00                	push   $0x0
  pushl $236
801065e9:	68 ec 00 00 00       	push   $0xec
  jmp alltraps
801065ee:	e9 b4 f1 ff ff       	jmp    801057a7 <alltraps>

801065f3 <vector237>:
.globl vector237
vector237:
  pushl $0
801065f3:	6a 00                	push   $0x0
  pushl $237
801065f5:	68 ed 00 00 00       	push   $0xed
  jmp alltraps
801065fa:	e9 a8 f1 ff ff       	jmp    801057a7 <alltraps>

801065ff <vector238>:
.globl vector238
vector238:
  pushl $0
801065ff:	6a 00                	push   $0x0
  pushl $238
80106601:	68 ee 00 00 00       	push   $0xee
  jmp alltraps
80106606:	e9 9c f1 ff ff       	jmp    801057a7 <alltraps>

8010660b <vector239>:
.globl vector239
vector239:
  pushl $0
8010660b:	6a 00                	push   $0x0
  pushl $239
8010660d:	68 ef 00 00 00       	push   $0xef
  jmp alltraps
80106612:	e9 90 f1 ff ff       	jmp    801057a7 <alltraps>

80106617 <vector240>:
.globl vector240
vector240:
  pushl $0
80106617:	6a 00                	push   $0x0
  pushl $240
80106619:	68 f0 00 00 00       	push   $0xf0
  jmp alltraps
8010661e:	e9 84 f1 ff ff       	jmp    801057a7 <alltraps>

80106623 <vector241>:
.globl vector241
vector241:
  pushl $0
80106623:	6a 00                	push   $0x0
  pushl $241
80106625:	68 f1 00 00 00       	push   $0xf1
  jmp alltraps
8010662a:	e9 78 f1 ff ff       	jmp    801057a7 <alltraps>

8010662f <vector242>:
.globl vector242
vector242:
  pushl $0
8010662f:	6a 00                	push   $0x0
  pushl $242
80106631:	68 f2 00 00 00       	push   $0xf2
  jmp alltraps
80106636:	e9 6c f1 ff ff       	jmp    801057a7 <alltraps>

8010663b <vector243>:
.globl vector243
vector243:
  pushl $0
8010663b:	6a 00                	push   $0x0
  pushl $243
8010663d:	68 f3 00 00 00       	push   $0xf3
  jmp alltraps
80106642:	e9 60 f1 ff ff       	jmp    801057a7 <alltraps>

80106647 <vector244>:
.globl vector244
vector244:
  pushl $0
80106647:	6a 00                	push   $0x0
  pushl $244
80106649:	68 f4 00 00 00       	push   $0xf4
  jmp alltraps
8010664e:	e9 54 f1 ff ff       	jmp    801057a7 <alltraps>

80106653 <vector245>:
.globl vector245
vector245:
  pushl $0
80106653:	6a 00                	push   $0x0
  pushl $245
80106655:	68 f5 00 00 00       	push   $0xf5
  jmp alltraps
8010665a:	e9 48 f1 ff ff       	jmp    801057a7 <alltraps>

8010665f <vector246>:
.globl vector246
vector246:
  pushl $0
8010665f:	6a 00                	push   $0x0
  pushl $246
80106661:	68 f6 00 00 00       	push   $0xf6
  jmp alltraps
80106666:	e9 3c f1 ff ff       	jmp    801057a7 <alltraps>

8010666b <vector247>:
.globl vector247
vector247:
  pushl $0
8010666b:	6a 00                	push   $0x0
  pushl $247
8010666d:	68 f7 00 00 00       	push   $0xf7
  jmp alltraps
80106672:	e9 30 f1 ff ff       	jmp    801057a7 <alltraps>

80106677 <vector248>:
.globl vector248
vector248:
  pushl $0
80106677:	6a 00                	push   $0x0
  pushl $248
80106679:	68 f8 00 00 00       	push   $0xf8
  jmp alltraps
8010667e:	e9 24 f1 ff ff       	jmp    801057a7 <alltraps>

80106683 <vector249>:
.globl vector249
vector249:
  pushl $0
80106683:	6a 00                	push   $0x0
  pushl $249
80106685:	68 f9 00 00 00       	push   $0xf9
  jmp alltraps
8010668a:	e9 18 f1 ff ff       	jmp    801057a7 <alltraps>

8010668f <vector250>:
.globl vector250
vector250:
  pushl $0
8010668f:	6a 00                	push   $0x0
  pushl $250
80106691:	68 fa 00 00 00       	push   $0xfa
  jmp alltraps
80106696:	e9 0c f1 ff ff       	jmp    801057a7 <alltraps>

8010669b <vector251>:
.globl vector251
vector251:
  pushl $0
8010669b:	6a 00                	push   $0x0
  pushl $251
8010669d:	68 fb 00 00 00       	push   $0xfb
  jmp alltraps
801066a2:	e9 00 f1 ff ff       	jmp    801057a7 <alltraps>

801066a7 <vector252>:
.globl vector252
vector252:
  pushl $0
801066a7:	6a 00                	push   $0x0
  pushl $252
801066a9:	68 fc 00 00 00       	push   $0xfc
  jmp alltraps
801066ae:	e9 f4 f0 ff ff       	jmp    801057a7 <alltraps>

801066b3 <vector253>:
.globl vector253
vector253:
  pushl $0
801066b3:	6a 00                	push   $0x0
  pushl $253
801066b5:	68 fd 00 00 00       	push   $0xfd
  jmp alltraps
801066ba:	e9 e8 f0 ff ff       	jmp    801057a7 <alltraps>

801066bf <vector254>:
.globl vector254
vector254:
  pushl $0
801066bf:	6a 00                	push   $0x0
  pushl $254
801066c1:	68 fe 00 00 00       	push   $0xfe
  jmp alltraps
801066c6:	e9 dc f0 ff ff       	jmp    801057a7 <alltraps>

801066cb <vector255>:
.globl vector255
vector255:
  pushl $0
801066cb:	6a 00                	push   $0x0
  pushl $255
801066cd:	68 ff 00 00 00       	push   $0xff
  jmp alltraps
801066d2:	e9 d0 f0 ff ff       	jmp    801057a7 <alltraps>
801066d7:	66 90                	xchg   %ax,%ax
801066d9:	66 90                	xchg   %ax,%ax
801066db:	66 90                	xchg   %ax,%ax
801066dd:	66 90                	xchg   %ax,%ax
801066df:	90                   	nop

801066e0 <walkpgdir>:
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066e0:	55                   	push   %ebp
801066e1:	89 e5                	mov    %esp,%ebp
801066e3:	57                   	push   %edi
801066e4:	56                   	push   %esi
801066e5:	53                   	push   %ebx
801066e6:	89 d3                	mov    %edx,%ebx
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
801066e8:	c1 ea 16             	shr    $0x16,%edx
801066eb:	8d 3c 90             	lea    (%eax,%edx,4),%edi
// Return the address of the PTE in page table pgdir
// that corresponds to virtual address va.  If alloc!=0,
// create any required page table pages.
static pte_t *
walkpgdir(pde_t *pgdir, const void *va, int alloc)
{
801066ee:	83 ec 0c             	sub    $0xc,%esp
  pde_t *pde;
  pte_t *pgtab;

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
801066f1:	8b 07                	mov    (%edi),%eax
801066f3:	a8 01                	test   $0x1,%al
801066f5:	74 29                	je     80106720 <walkpgdir+0x40>
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
801066f7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
801066fc:	8d b0 00 00 00 80    	lea    -0x80000000(%eax),%esi
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106702:	8d 65 f4             	lea    -0xc(%ebp),%esp
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
80106705:	c1 eb 0a             	shr    $0xa,%ebx
80106708:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
8010670e:	8d 04 1e             	lea    (%esi,%ebx,1),%eax
}
80106711:	5b                   	pop    %ebx
80106712:	5e                   	pop    %esi
80106713:	5f                   	pop    %edi
80106714:	5d                   	pop    %ebp
80106715:	c3                   	ret    
80106716:	8d 76 00             	lea    0x0(%esi),%esi
80106719:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
80106720:	85 c9                	test   %ecx,%ecx
80106722:	74 2c                	je     80106750 <walkpgdir+0x70>
80106724:	e8 67 bd ff ff       	call   80102490 <kalloc>
80106729:	85 c0                	test   %eax,%eax
8010672b:	89 c6                	mov    %eax,%esi
8010672d:	74 21                	je     80106750 <walkpgdir+0x70>
      return 0;
    // Make sure all those PTE_P bits are zero.
    memset(pgtab, 0, PGSIZE);
8010672f:	83 ec 04             	sub    $0x4,%esp
80106732:	68 00 10 00 00       	push   $0x1000
80106737:	6a 00                	push   $0x0
80106739:	50                   	push   %eax
8010673a:	e8 11 dd ff ff       	call   80104450 <memset>
    // The permissions here are overly generous, but they can
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
8010673f:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106745:	83 c4 10             	add    $0x10,%esp
80106748:	83 c8 07             	or     $0x7,%eax
8010674b:	89 07                	mov    %eax,(%edi)
8010674d:	eb b3                	jmp    80106702 <walkpgdir+0x22>
8010674f:	90                   	nop
  }
  return &pgtab[PTX(va)];
}
80106750:	8d 65 f4             	lea    -0xc(%ebp),%esp
  pde = &pgdir[PDX(va)];
  if(*pde & PTE_P){
    pgtab = (pte_t*)P2V(PTE_ADDR(*pde));
  } else {
    if(!alloc || (pgtab = (pte_t*)kalloc()) == 0)
      return 0;
80106753:	31 c0                	xor    %eax,%eax
    // be further restricted by the permissions in the page table
    // entries, if necessary.
    *pde = V2P(pgtab) | PTE_P | PTE_W | PTE_U;
  }
  return &pgtab[PTX(va)];
}
80106755:	5b                   	pop    %ebx
80106756:	5e                   	pop    %esi
80106757:	5f                   	pop    %edi
80106758:	5d                   	pop    %ebp
80106759:	c3                   	ret    
8010675a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106760 <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
80106760:	55                   	push   %ebp
80106761:	89 e5                	mov    %esp,%ebp
80106763:	57                   	push   %edi
80106764:	56                   	push   %esi
80106765:	53                   	push   %ebx
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
80106766:	89 d3                	mov    %edx,%ebx
80106768:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned.
static int
mappages(pde_t *pgdir, void *va, uint size, uint pa, int perm)
{
8010676e:	83 ec 1c             	sub    $0x1c,%esp
80106771:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *a, *last;
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
80106774:	8d 44 0a ff          	lea    -0x1(%edx,%ecx,1),%eax
80106778:	8b 7d 08             	mov    0x8(%ebp),%edi
8010677b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106780:	89 45 e0             	mov    %eax,-0x20(%ebp)
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
80106783:	8b 45 0c             	mov    0xc(%ebp),%eax
80106786:	29 df                	sub    %ebx,%edi
80106788:	83 c8 01             	or     $0x1,%eax
8010678b:	89 45 dc             	mov    %eax,-0x24(%ebp)
8010678e:	eb 15                	jmp    801067a5 <mappages+0x45>
  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
80106790:	f6 00 01             	testb  $0x1,(%eax)
80106793:	75 45                	jne    801067da <mappages+0x7a>
      panic("remap");
    *pte = pa | perm | PTE_P;
80106795:	0b 75 dc             	or     -0x24(%ebp),%esi
    if(a == last)
80106798:	3b 5d e0             	cmp    -0x20(%ebp),%ebx
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
    *pte = pa | perm | PTE_P;
8010679b:	89 30                	mov    %esi,(%eax)
    if(a == last)
8010679d:	74 31                	je     801067d0 <mappages+0x70>
      break;
    a += PGSIZE;
8010679f:	81 c3 00 10 00 00    	add    $0x1000,%ebx
  pte_t *pte;

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
801067a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
801067a8:	b9 01 00 00 00       	mov    $0x1,%ecx
801067ad:	89 da                	mov    %ebx,%edx
801067af:	8d 34 3b             	lea    (%ebx,%edi,1),%esi
801067b2:	e8 29 ff ff ff       	call   801066e0 <walkpgdir>
801067b7:	85 c0                	test   %eax,%eax
801067b9:	75 d5                	jne    80106790 <mappages+0x30>
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801067bb:	8d 65 f4             	lea    -0xc(%ebp),%esp

  a = (char*)PGROUNDDOWN((uint)va);
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
801067be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
}
801067c3:	5b                   	pop    %ebx
801067c4:	5e                   	pop    %esi
801067c5:	5f                   	pop    %edi
801067c6:	5d                   	pop    %ebp
801067c7:	c3                   	ret    
801067c8:	90                   	nop
801067c9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801067d0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(a == last)
      break;
    a += PGSIZE;
    pa += PGSIZE;
  }
  return 0;
801067d3:	31 c0                	xor    %eax,%eax
}
801067d5:	5b                   	pop    %ebx
801067d6:	5e                   	pop    %esi
801067d7:	5f                   	pop    %edi
801067d8:	5d                   	pop    %ebp
801067d9:	c3                   	ret    
  last = (char*)PGROUNDDOWN(((uint)va) + size - 1);
  for(;;){
    if((pte = walkpgdir(pgdir, a, 1)) == 0)
      return -1;
    if(*pte & PTE_P)
      panic("remap");
801067da:	83 ec 0c             	sub    $0xc,%esp
801067dd:	68 9c 79 10 80       	push   $0x8010799c
801067e2:	e8 89 9b ff ff       	call   80100370 <panic>
801067e7:	89 f6                	mov    %esi,%esi
801067e9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801067f0 <deallocuvm.part.0>:
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067f0:	55                   	push   %ebp
801067f1:	89 e5                	mov    %esp,%ebp
801067f3:	57                   	push   %edi
801067f4:	56                   	push   %esi
801067f5:	53                   	push   %ebx
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067f6:	8d 99 ff 0f 00 00    	lea    0xfff(%ecx),%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
801067fc:	89 c7                	mov    %eax,%edi
  uint a, pa;

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
801067fe:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
// Deallocate user pages to bring the process size from oldsz to
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
80106804:	83 ec 1c             	sub    $0x1c,%esp
80106807:	89 4d e0             	mov    %ecx,-0x20(%ebp)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010680a:	39 d3                	cmp    %edx,%ebx
8010680c:	73 66                	jae    80106874 <deallocuvm.part.0+0x84>
8010680e:	89 d6                	mov    %edx,%esi
80106810:	eb 3d                	jmp    8010684f <deallocuvm.part.0+0x5f>
80106812:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
    pte = walkpgdir(pgdir, (char*)a, 0);
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
80106818:	8b 10                	mov    (%eax),%edx
8010681a:	f6 c2 01             	test   $0x1,%dl
8010681d:	74 26                	je     80106845 <deallocuvm.part.0+0x55>
      pa = PTE_ADDR(*pte);
      if(pa == 0)
8010681f:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
80106825:	74 58                	je     8010687f <deallocuvm.part.0+0x8f>
        panic("kfree");
      char *v = P2V(pa);
      kfree(v);
80106827:	83 ec 0c             	sub    $0xc,%esp
8010682a:	81 c2 00 00 00 80    	add    $0x80000000,%edx
80106830:	89 45 e4             	mov    %eax,-0x1c(%ebp)
80106833:	52                   	push   %edx
80106834:	e8 a7 ba ff ff       	call   801022e0 <kfree>
      *pte = 0;
80106839:	8b 45 e4             	mov    -0x1c(%ebp),%eax
8010683c:	83 c4 10             	add    $0x10,%esp
8010683f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
80106845:	81 c3 00 10 00 00    	add    $0x1000,%ebx
8010684b:	39 f3                	cmp    %esi,%ebx
8010684d:	73 25                	jae    80106874 <deallocuvm.part.0+0x84>
    pte = walkpgdir(pgdir, (char*)a, 0);
8010684f:	31 c9                	xor    %ecx,%ecx
80106851:	89 da                	mov    %ebx,%edx
80106853:	89 f8                	mov    %edi,%eax
80106855:	e8 86 fe ff ff       	call   801066e0 <walkpgdir>
    if(!pte)
8010685a:	85 c0                	test   %eax,%eax
8010685c:	75 ba                	jne    80106818 <deallocuvm.part.0+0x28>
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
8010685e:	81 e3 00 00 c0 ff    	and    $0xffc00000,%ebx
80106864:	81 c3 00 f0 3f 00    	add    $0x3ff000,%ebx

  if(newsz >= oldsz)
    return oldsz;

  a = PGROUNDUP(newsz);
  for(; a  < oldsz; a += PGSIZE){
8010686a:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106870:	39 f3                	cmp    %esi,%ebx
80106872:	72 db                	jb     8010684f <deallocuvm.part.0+0x5f>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106874:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106877:	8d 65 f4             	lea    -0xc(%ebp),%esp
8010687a:	5b                   	pop    %ebx
8010687b:	5e                   	pop    %esi
8010687c:	5f                   	pop    %edi
8010687d:	5d                   	pop    %ebp
8010687e:	c3                   	ret    
    if(!pte)
      a = PGADDR(PDX(a) + 1, 0, 0) - PGSIZE;
    else if((*pte & PTE_P) != 0){
      pa = PTE_ADDR(*pte);
      if(pa == 0)
        panic("kfree");
8010687f:	83 ec 0c             	sub    $0xc,%esp
80106882:	68 c6 72 10 80       	push   $0x801072c6
80106887:	e8 e4 9a ff ff       	call   80100370 <panic>
8010688c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106890 <seginit>:

// Set up CPU's kernel segment descriptors.
// Run once on entry on each CPU.
void
seginit(void)
{
80106890:	55                   	push   %ebp
80106891:	89 e5                	mov    %esp,%ebp
80106893:	83 ec 18             	sub    $0x18,%esp

  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
80106896:	e8 e5 ce ff ff       	call   80103780 <cpuid>
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
8010689b:	69 c0 b0 00 00 00    	imul   $0xb0,%eax,%eax
801068a1:	31 c9                	xor    %ecx,%ecx
801068a3:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801068a8:	66 89 90 58 28 11 80 	mov    %dx,-0x7feed7a8(%eax)
801068af:	66 89 88 5a 28 11 80 	mov    %cx,-0x7feed7a6(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068b6:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801068bb:	31 c9                	xor    %ecx,%ecx
801068bd:	66 89 90 60 28 11 80 	mov    %dx,-0x7feed7a0(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068c4:	ba ff ff ff ff       	mov    $0xffffffff,%edx
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
801068c9:	66 89 88 62 28 11 80 	mov    %cx,-0x7feed79e(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
801068d0:	31 c9                	xor    %ecx,%ecx
801068d2:	66 89 90 68 28 11 80 	mov    %dx,-0x7feed798(%eax)
801068d9:	66 89 88 6a 28 11 80 	mov    %cx,-0x7feed796(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
801068e0:	ba ff ff ff ff       	mov    $0xffffffff,%edx
801068e5:	31 c9                	xor    %ecx,%ecx
801068e7:	66 89 90 70 28 11 80 	mov    %dx,-0x7feed790(%eax)
  // Map "logical" addresses to virtual addresses using identity map.
  // Cannot share a CODE descriptor for both kernel and user
  // because it would have to have DPL_USR, but the CPU forbids
  // an interrupt from CPL=0 to DPL=3.
  c = &cpus[cpuid()];
  c->gdt[SEG_KCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, 0);
801068ee:	c6 80 5c 28 11 80 00 	movb   $0x0,-0x7feed7a4(%eax)
static inline void
lgdt(struct segdesc *p, int size)
{
  volatile ushort pd[3];

  pd[0] = size-1;
801068f5:	ba 2f 00 00 00       	mov    $0x2f,%edx
801068fa:	c6 80 5d 28 11 80 9a 	movb   $0x9a,-0x7feed7a3(%eax)
80106901:	c6 80 5e 28 11 80 cf 	movb   $0xcf,-0x7feed7a2(%eax)
80106908:	c6 80 5f 28 11 80 00 	movb   $0x0,-0x7feed7a1(%eax)
  c->gdt[SEG_KDATA] = SEG(STA_W, 0, 0xffffffff, 0);
8010690f:	c6 80 64 28 11 80 00 	movb   $0x0,-0x7feed79c(%eax)
80106916:	c6 80 65 28 11 80 92 	movb   $0x92,-0x7feed79b(%eax)
8010691d:	c6 80 66 28 11 80 cf 	movb   $0xcf,-0x7feed79a(%eax)
80106924:	c6 80 67 28 11 80 00 	movb   $0x0,-0x7feed799(%eax)
  c->gdt[SEG_UCODE] = SEG(STA_X|STA_R, 0, 0xffffffff, DPL_USER);
8010692b:	c6 80 6c 28 11 80 00 	movb   $0x0,-0x7feed794(%eax)
80106932:	c6 80 6d 28 11 80 fa 	movb   $0xfa,-0x7feed793(%eax)
80106939:	c6 80 6e 28 11 80 cf 	movb   $0xcf,-0x7feed792(%eax)
80106940:	c6 80 6f 28 11 80 00 	movb   $0x0,-0x7feed791(%eax)
  c->gdt[SEG_UDATA] = SEG(STA_W, 0, 0xffffffff, DPL_USER);
80106947:	66 89 88 72 28 11 80 	mov    %cx,-0x7feed78e(%eax)
8010694e:	c6 80 74 28 11 80 00 	movb   $0x0,-0x7feed78c(%eax)
80106955:	c6 80 75 28 11 80 f2 	movb   $0xf2,-0x7feed78b(%eax)
8010695c:	c6 80 76 28 11 80 cf 	movb   $0xcf,-0x7feed78a(%eax)
80106963:	c6 80 77 28 11 80 00 	movb   $0x0,-0x7feed789(%eax)
  lgdt(c->gdt, sizeof(c->gdt));
8010696a:	05 50 28 11 80       	add    $0x80112850,%eax
8010696f:	66 89 55 f2          	mov    %dx,-0xe(%ebp)
  pd[1] = (uint)p;
80106973:	66 89 45 f4          	mov    %ax,-0xc(%ebp)
  pd[2] = (uint)p >> 16;
80106977:	c1 e8 10             	shr    $0x10,%eax
8010697a:	66 89 45 f6          	mov    %ax,-0xa(%ebp)

  asm volatile("lgdt (%0)" : : "r" (pd));
8010697e:	8d 45 f2             	lea    -0xe(%ebp),%eax
80106981:	0f 01 10             	lgdtl  (%eax)
}
80106984:	c9                   	leave  
80106985:	c3                   	ret    
80106986:	8d 76 00             	lea    0x0(%esi),%esi
80106989:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106990 <switchkvm>:
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106990:	a1 04 57 11 80       	mov    0x80115704,%eax

// Switch h/w page table register to the kernel-only page table,
// for when no process is running.
void
switchkvm(void)
{
80106995:	55                   	push   %ebp
80106996:	89 e5                	mov    %esp,%ebp
80106998:	05 00 00 00 80       	add    $0x80000000,%eax
8010699d:	0f 22 d8             	mov    %eax,%cr3
  lcr3(V2P(kpgdir));   // switch to the kernel page table
}
801069a0:	5d                   	pop    %ebp
801069a1:	c3                   	ret    
801069a2:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
801069a9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

801069b0 <switchuvm>:

// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
801069b0:	55                   	push   %ebp
801069b1:	89 e5                	mov    %esp,%ebp
801069b3:	57                   	push   %edi
801069b4:	56                   	push   %esi
801069b5:	53                   	push   %ebx
801069b6:	83 ec 1c             	sub    $0x1c,%esp
801069b9:	8b 75 08             	mov    0x8(%ebp),%esi
  if(p == 0)
801069bc:	85 f6                	test   %esi,%esi
801069be:	0f 84 cd 00 00 00    	je     80106a91 <switchuvm+0xe1>
    panic("switchuvm: no process");
  if(p->kstack == 0)
801069c4:	8b 46 10             	mov    0x10(%esi),%eax
801069c7:	85 c0                	test   %eax,%eax
801069c9:	0f 84 dc 00 00 00    	je     80106aab <switchuvm+0xfb>
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
801069cf:	8b 7e 0c             	mov    0xc(%esi),%edi
801069d2:	85 ff                	test   %edi,%edi
801069d4:	0f 84 c4 00 00 00    	je     80106a9e <switchuvm+0xee>
    panic("switchuvm: no pgdir");

  pushcli();
801069da:	e8 91 d8 ff ff       	call   80104270 <pushcli>
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
801069df:	e8 1c cd ff ff       	call   80103700 <mycpu>
801069e4:	89 c3                	mov    %eax,%ebx
801069e6:	e8 15 cd ff ff       	call   80103700 <mycpu>
801069eb:	89 c7                	mov    %eax,%edi
801069ed:	e8 0e cd ff ff       	call   80103700 <mycpu>
801069f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
801069f5:	83 c7 08             	add    $0x8,%edi
801069f8:	e8 03 cd ff ff       	call   80103700 <mycpu>
801069fd:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
80106a00:	83 c0 08             	add    $0x8,%eax
80106a03:	ba 67 00 00 00       	mov    $0x67,%edx
80106a08:	c1 e8 18             	shr    $0x18,%eax
80106a0b:	66 89 93 98 00 00 00 	mov    %dx,0x98(%ebx)
80106a12:	66 89 bb 9a 00 00 00 	mov    %di,0x9a(%ebx)
80106a19:	c6 83 9d 00 00 00 99 	movb   $0x99,0x9d(%ebx)
80106a20:	c6 83 9e 00 00 00 40 	movb   $0x40,0x9e(%ebx)
80106a27:	83 c1 08             	add    $0x8,%ecx
80106a2a:	88 83 9f 00 00 00    	mov    %al,0x9f(%ebx)
80106a30:	c1 e9 10             	shr    $0x10,%ecx
80106a33:	88 8b 9c 00 00 00    	mov    %cl,0x9c(%ebx)
  mycpu()->gdt[SEG_TSS].s = 0;
  mycpu()->ts.ss0 = SEG_KDATA << 3;
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a39:	bb ff ff ff ff       	mov    $0xffffffff,%ebx
    panic("switchuvm: no pgdir");

  pushcli();
  mycpu()->gdt[SEG_TSS] = SEG16(STS_T32A, &mycpu()->ts,
                                sizeof(mycpu()->ts)-1, 0);
  mycpu()->gdt[SEG_TSS].s = 0;
80106a3e:	e8 bd cc ff ff       	call   80103700 <mycpu>
80106a43:	80 a0 9d 00 00 00 ef 	andb   $0xef,0x9d(%eax)
  mycpu()->ts.ss0 = SEG_KDATA << 3;
80106a4a:	e8 b1 cc ff ff       	call   80103700 <mycpu>
80106a4f:	b9 10 00 00 00       	mov    $0x10,%ecx
80106a54:	66 89 48 10          	mov    %cx,0x10(%eax)
  mycpu()->ts.esp0 = (uint)p->kstack + KSTACKSIZE;
80106a58:	e8 a3 cc ff ff       	call   80103700 <mycpu>
80106a5d:	8b 56 10             	mov    0x10(%esi),%edx
80106a60:	8d 8a 00 10 00 00    	lea    0x1000(%edx),%ecx
80106a66:	89 48 0c             	mov    %ecx,0xc(%eax)
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
80106a69:	e8 92 cc ff ff       	call   80103700 <mycpu>
80106a6e:	66 89 58 6e          	mov    %bx,0x6e(%eax)
}

static inline void
ltr(ushort sel)
{
  asm volatile("ltr %0" : : "r" (sel));
80106a72:	b8 28 00 00 00       	mov    $0x28,%eax
80106a77:	0f 00 d8             	ltr    %ax
}

static inline void
lcr3(uint val)
{
  asm volatile("movl %0,%%cr3" : : "r" (val));
80106a7a:	8b 46 0c             	mov    0xc(%esi),%eax
80106a7d:	05 00 00 00 80       	add    $0x80000000,%eax
80106a82:	0f 22 d8             	mov    %eax,%cr3
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
}
80106a85:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106a88:	5b                   	pop    %ebx
80106a89:	5e                   	pop    %esi
80106a8a:	5f                   	pop    %edi
80106a8b:	5d                   	pop    %ebp
  // setting IOPL=0 in eflags *and* iomb beyond the tss segment limit
  // forbids I/O instructions (e.g., inb and outb) from user space
  mycpu()->ts.iomb = (ushort) 0xFFFF;
  ltr(SEG_TSS << 3);
  lcr3(V2P(p->pgdir));  // switch to process's address space
  popcli();
80106a8c:	e9 1f d8 ff ff       	jmp    801042b0 <popcli>
// Switch TSS and h/w page table to correspond to process p.
void
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
80106a91:	83 ec 0c             	sub    $0xc,%esp
80106a94:	68 a2 79 10 80       	push   $0x801079a2
80106a99:	e8 d2 98 ff ff       	call   80100370 <panic>
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
  if(p->pgdir == 0)
    panic("switchuvm: no pgdir");
80106a9e:	83 ec 0c             	sub    $0xc,%esp
80106aa1:	68 cd 79 10 80       	push   $0x801079cd
80106aa6:	e8 c5 98 ff ff       	call   80100370 <panic>
switchuvm(struct proc *p)
{
  if(p == 0)
    panic("switchuvm: no process");
  if(p->kstack == 0)
    panic("switchuvm: no kstack");
80106aab:	83 ec 0c             	sub    $0xc,%esp
80106aae:	68 b8 79 10 80       	push   $0x801079b8
80106ab3:	e8 b8 98 ff ff       	call   80100370 <panic>
80106ab8:	90                   	nop
80106ab9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106ac0 <inituvm>:

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ac0:	55                   	push   %ebp
80106ac1:	89 e5                	mov    %esp,%ebp
80106ac3:	57                   	push   %edi
80106ac4:	56                   	push   %esi
80106ac5:	53                   	push   %ebx
80106ac6:	83 ec 1c             	sub    $0x1c,%esp
80106ac9:	8b 75 10             	mov    0x10(%ebp),%esi
80106acc:	8b 45 08             	mov    0x8(%ebp),%eax
80106acf:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *mem;

  if(sz >= PGSIZE)
80106ad2:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi

// Load the initcode into address 0 of pgdir.
// sz must be less than a page.
void
inituvm(pde_t *pgdir, char *init, uint sz)
{
80106ad8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  char *mem;

  if(sz >= PGSIZE)
80106adb:	77 49                	ja     80106b26 <inituvm+0x66>
    panic("inituvm: more than a page");
  mem = kalloc();
80106add:	e8 ae b9 ff ff       	call   80102490 <kalloc>
  memset(mem, 0, PGSIZE);
80106ae2:	83 ec 04             	sub    $0x4,%esp
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
80106ae5:	89 c3                	mov    %eax,%ebx
  memset(mem, 0, PGSIZE);
80106ae7:	68 00 10 00 00       	push   $0x1000
80106aec:	6a 00                	push   $0x0
80106aee:	50                   	push   %eax
80106aef:	e8 5c d9 ff ff       	call   80104450 <memset>
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
80106af4:	58                   	pop    %eax
80106af5:	8d 83 00 00 00 80    	lea    -0x80000000(%ebx),%eax
80106afb:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106b00:	5a                   	pop    %edx
80106b01:	6a 06                	push   $0x6
80106b03:	50                   	push   %eax
80106b04:	31 d2                	xor    %edx,%edx
80106b06:	8b 45 e4             	mov    -0x1c(%ebp),%eax
80106b09:	e8 52 fc ff ff       	call   80106760 <mappages>
  memmove(mem, init, sz);
80106b0e:	89 75 10             	mov    %esi,0x10(%ebp)
80106b11:	89 7d 0c             	mov    %edi,0xc(%ebp)
80106b14:	83 c4 10             	add    $0x10,%esp
80106b17:	89 5d 08             	mov    %ebx,0x8(%ebp)
}
80106b1a:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106b1d:	5b                   	pop    %ebx
80106b1e:	5e                   	pop    %esi
80106b1f:	5f                   	pop    %edi
80106b20:	5d                   	pop    %ebp
  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
  mem = kalloc();
  memset(mem, 0, PGSIZE);
  mappages(pgdir, 0, PGSIZE, V2P(mem), PTE_W|PTE_U);
  memmove(mem, init, sz);
80106b21:	e9 da d9 ff ff       	jmp    80104500 <memmove>
inituvm(pde_t *pgdir, char *init, uint sz)
{
  char *mem;

  if(sz >= PGSIZE)
    panic("inituvm: more than a page");
80106b26:	83 ec 0c             	sub    $0xc,%esp
80106b29:	68 e1 79 10 80       	push   $0x801079e1
80106b2e:	e8 3d 98 ff ff       	call   80100370 <panic>
80106b33:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106b39:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106b40 <loaduvm>:

// Load a program segment into pgdir.  addr must be page-aligned
// and the pages from addr to addr+sz must already be mapped.
int
loaduvm(pde_t *pgdir, char *addr, struct inode *ip, uint offset, uint sz)
{
80106b40:	55                   	push   %ebp
80106b41:	89 e5                	mov    %esp,%ebp
80106b43:	57                   	push   %edi
80106b44:	56                   	push   %esi
80106b45:	53                   	push   %ebx
80106b46:	83 ec 0c             	sub    $0xc,%esp
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
80106b49:	f7 45 0c ff 0f 00 00 	testl  $0xfff,0xc(%ebp)
80106b50:	0f 85 91 00 00 00    	jne    80106be7 <loaduvm+0xa7>
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
80106b56:	8b 75 18             	mov    0x18(%ebp),%esi
80106b59:	31 db                	xor    %ebx,%ebx
80106b5b:	85 f6                	test   %esi,%esi
80106b5d:	75 1a                	jne    80106b79 <loaduvm+0x39>
80106b5f:	eb 6f                	jmp    80106bd0 <loaduvm+0x90>
80106b61:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106b68:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106b6e:	81 ee 00 10 00 00    	sub    $0x1000,%esi
80106b74:	39 5d 18             	cmp    %ebx,0x18(%ebp)
80106b77:	76 57                	jbe    80106bd0 <loaduvm+0x90>
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
80106b79:	8b 55 0c             	mov    0xc(%ebp),%edx
80106b7c:	8b 45 08             	mov    0x8(%ebp),%eax
80106b7f:	31 c9                	xor    %ecx,%ecx
80106b81:	01 da                	add    %ebx,%edx
80106b83:	e8 58 fb ff ff       	call   801066e0 <walkpgdir>
80106b88:	85 c0                	test   %eax,%eax
80106b8a:	74 4e                	je     80106bda <loaduvm+0x9a>
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b8c:	8b 00                	mov    (%eax),%eax
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106b8e:	8b 4d 14             	mov    0x14(%ebp),%ecx
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
    if(sz - i < PGSIZE)
80106b91:	bf 00 10 00 00       	mov    $0x1000,%edi
  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
    pa = PTE_ADDR(*pte);
80106b96:	25 00 f0 ff ff       	and    $0xfffff000,%eax
    if(sz - i < PGSIZE)
80106b9b:	81 fe ff 0f 00 00    	cmp    $0xfff,%esi
80106ba1:	0f 46 fe             	cmovbe %esi,%edi
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
80106ba4:	01 d9                	add    %ebx,%ecx
80106ba6:	05 00 00 00 80       	add    $0x80000000,%eax
80106bab:	57                   	push   %edi
80106bac:	51                   	push   %ecx
80106bad:	50                   	push   %eax
80106bae:	ff 75 10             	pushl  0x10(%ebp)
80106bb1:	e8 9a ad ff ff       	call   80101950 <readi>
80106bb6:	83 c4 10             	add    $0x10,%esp
80106bb9:	39 c7                	cmp    %eax,%edi
80106bbb:	74 ab                	je     80106b68 <loaduvm+0x28>
      return -1;
  }
  return 0;
}
80106bbd:	8d 65 f4             	lea    -0xc(%ebp),%esp
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
80106bc0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  }
  return 0;
}
80106bc5:	5b                   	pop    %ebx
80106bc6:	5e                   	pop    %esi
80106bc7:	5f                   	pop    %edi
80106bc8:	5d                   	pop    %ebp
80106bc9:	c3                   	ret    
80106bca:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bd0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    else
      n = PGSIZE;
    if(readi(ip, P2V(pa), offset+i, n) != n)
      return -1;
  }
  return 0;
80106bd3:	31 c0                	xor    %eax,%eax
}
80106bd5:	5b                   	pop    %ebx
80106bd6:	5e                   	pop    %esi
80106bd7:	5f                   	pop    %edi
80106bd8:	5d                   	pop    %ebp
80106bd9:	c3                   	ret    

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, addr+i, 0)) == 0)
      panic("loaduvm: address should exist");
80106bda:	83 ec 0c             	sub    $0xc,%esp
80106bdd:	68 fb 79 10 80       	push   $0x801079fb
80106be2:	e8 89 97 ff ff       	call   80100370 <panic>
{
  uint i, pa, n;
  pte_t *pte;

  if((uint) addr % PGSIZE != 0)
    panic("loaduvm: addr must be page aligned");
80106be7:	83 ec 0c             	sub    $0xc,%esp
80106bea:	68 9c 7a 10 80       	push   $0x80107a9c
80106bef:	e8 7c 97 ff ff       	call   80100370 <panic>
80106bf4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106bfa:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106c00 <allocuvm>:

// Allocate page tables and physical memory to grow process from oldsz to
// newsz, which need not be page aligned.  Returns new size or 0 on error.
int
allocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106c00:	55                   	push   %ebp
80106c01:	89 e5                	mov    %esp,%ebp
80106c03:	57                   	push   %edi
80106c04:	56                   	push   %esi
80106c05:	53                   	push   %ebx
80106c06:	83 ec 0c             	sub    $0xc,%esp
80106c09:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
80106c0c:	85 ff                	test   %edi,%edi
80106c0e:	0f 88 ca 00 00 00    	js     80106cde <allocuvm+0xde>
    return 0;
  if(newsz < oldsz)
80106c14:	3b 7d 0c             	cmp    0xc(%ebp),%edi
    return oldsz;
80106c17:	8b 45 0c             	mov    0xc(%ebp),%eax
  char *mem;
  uint a;

  if(newsz >= KERNBASE)
    return 0;
  if(newsz < oldsz)
80106c1a:	0f 82 82 00 00 00    	jb     80106ca2 <allocuvm+0xa2>
    return oldsz;

  a = PGROUNDUP(oldsz);
80106c20:	8d 98 ff 0f 00 00    	lea    0xfff(%eax),%ebx
80106c26:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
  for(; a < newsz; a += PGSIZE){
80106c2c:	39 df                	cmp    %ebx,%edi
80106c2e:	77 43                	ja     80106c73 <allocuvm+0x73>
80106c30:	e9 bb 00 00 00       	jmp    80106cf0 <allocuvm+0xf0>
80106c35:	8d 76 00             	lea    0x0(%esi),%esi
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
80106c38:	83 ec 04             	sub    $0x4,%esp
80106c3b:	68 00 10 00 00       	push   $0x1000
80106c40:	6a 00                	push   $0x0
80106c42:	50                   	push   %eax
80106c43:	e8 08 d8 ff ff       	call   80104450 <memset>
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
80106c48:	58                   	pop    %eax
80106c49:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106c4f:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106c54:	5a                   	pop    %edx
80106c55:	6a 06                	push   $0x6
80106c57:	50                   	push   %eax
80106c58:	89 da                	mov    %ebx,%edx
80106c5a:	8b 45 08             	mov    0x8(%ebp),%eax
80106c5d:	e8 fe fa ff ff       	call   80106760 <mappages>
80106c62:	83 c4 10             	add    $0x10,%esp
80106c65:	85 c0                	test   %eax,%eax
80106c67:	78 47                	js     80106cb0 <allocuvm+0xb0>
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106c69:	81 c3 00 10 00 00    	add    $0x1000,%ebx
80106c6f:	39 df                	cmp    %ebx,%edi
80106c71:	76 7d                	jbe    80106cf0 <allocuvm+0xf0>
    mem = kalloc();
80106c73:	e8 18 b8 ff ff       	call   80102490 <kalloc>
    if(mem == 0){
80106c78:	85 c0                	test   %eax,%eax
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
80106c7a:	89 c6                	mov    %eax,%esi
    if(mem == 0){
80106c7c:	75 ba                	jne    80106c38 <allocuvm+0x38>
      cprintf("allocuvm out of memory\n");
80106c7e:	83 ec 0c             	sub    $0xc,%esp
80106c81:	68 19 7a 10 80       	push   $0x80107a19
80106c86:	e8 d5 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106c8b:	83 c4 10             	add    $0x10,%esp
80106c8e:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106c91:	76 4b                	jbe    80106cde <allocuvm+0xde>
80106c93:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106c96:	8b 45 08             	mov    0x8(%ebp),%eax
80106c99:	89 fa                	mov    %edi,%edx
80106c9b:	e8 50 fb ff ff       	call   801067f0 <deallocuvm.part.0>
  for(; a < newsz; a += PGSIZE){
    mem = kalloc();
    if(mem == 0){
      cprintf("allocuvm out of memory\n");
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
80106ca0:	31 c0                	xor    %eax,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106ca2:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106ca5:	5b                   	pop    %ebx
80106ca6:	5e                   	pop    %esi
80106ca7:	5f                   	pop    %edi
80106ca8:	5d                   	pop    %ebp
80106ca9:	c3                   	ret    
80106caa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
      deallocuvm(pgdir, newsz, oldsz);
      return 0;
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
80106cb0:	83 ec 0c             	sub    $0xc,%esp
80106cb3:	68 31 7a 10 80       	push   $0x80107a31
80106cb8:	e8 a3 99 ff ff       	call   80100660 <cprintf>
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106cbd:	83 c4 10             	add    $0x10,%esp
80106cc0:	3b 7d 0c             	cmp    0xc(%ebp),%edi
80106cc3:	76 0d                	jbe    80106cd2 <allocuvm+0xd2>
80106cc5:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106cc8:	8b 45 08             	mov    0x8(%ebp),%eax
80106ccb:	89 fa                	mov    %edi,%edx
80106ccd:	e8 1e fb ff ff       	call   801067f0 <deallocuvm.part.0>
    }
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
80106cd2:	83 ec 0c             	sub    $0xc,%esp
80106cd5:	56                   	push   %esi
80106cd6:	e8 05 b6 ff ff       	call   801022e0 <kfree>
      return 0;
80106cdb:	83 c4 10             	add    $0x10,%esp
    }
  }
  return newsz;
}
80106cde:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memset(mem, 0, PGSIZE);
    if(mappages(pgdir, (char*)a, PGSIZE, V2P(mem), PTE_W|PTE_U) < 0){
      cprintf("allocuvm out of memory (2)\n");
      deallocuvm(pgdir, newsz, oldsz);
      kfree(mem);
      return 0;
80106ce1:	31 c0                	xor    %eax,%eax
    }
  }
  return newsz;
}
80106ce3:	5b                   	pop    %ebx
80106ce4:	5e                   	pop    %esi
80106ce5:	5f                   	pop    %edi
80106ce6:	5d                   	pop    %ebp
80106ce7:	c3                   	ret    
80106ce8:	90                   	nop
80106ce9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106cf0:	8d 65 f4             	lea    -0xc(%ebp),%esp
    return 0;
  if(newsz < oldsz)
    return oldsz;

  a = PGROUNDUP(oldsz);
  for(; a < newsz; a += PGSIZE){
80106cf3:	89 f8                	mov    %edi,%eax
      kfree(mem);
      return 0;
    }
  }
  return newsz;
}
80106cf5:	5b                   	pop    %ebx
80106cf6:	5e                   	pop    %esi
80106cf7:	5f                   	pop    %edi
80106cf8:	5d                   	pop    %ebp
80106cf9:	c3                   	ret    
80106cfa:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106d00 <deallocuvm>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
int
deallocuvm(pde_t *pgdir, uint oldsz, uint newsz)
{
80106d00:	55                   	push   %ebp
80106d01:	89 e5                	mov    %esp,%ebp
80106d03:	8b 55 0c             	mov    0xc(%ebp),%edx
80106d06:	8b 4d 10             	mov    0x10(%ebp),%ecx
80106d09:	8b 45 08             	mov    0x8(%ebp),%eax
  pte_t *pte;
  uint a, pa;

  if(newsz >= oldsz)
80106d0c:	39 d1                	cmp    %edx,%ecx
80106d0e:	73 10                	jae    80106d20 <deallocuvm+0x20>
      kfree(v);
      *pte = 0;
    }
  }
  return newsz;
}
80106d10:	5d                   	pop    %ebp
80106d11:	e9 da fa ff ff       	jmp    801067f0 <deallocuvm.part.0>
80106d16:	8d 76 00             	lea    0x0(%esi),%esi
80106d19:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi
80106d20:	89 d0                	mov    %edx,%eax
80106d22:	5d                   	pop    %ebp
80106d23:	c3                   	ret    
80106d24:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106d2a:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106d30 <freevm>:

// Free a page table and all the physical memory pages
// in the user part.
void
freevm(pde_t *pgdir)
{
80106d30:	55                   	push   %ebp
80106d31:	89 e5                	mov    %esp,%ebp
80106d33:	57                   	push   %edi
80106d34:	56                   	push   %esi
80106d35:	53                   	push   %ebx
80106d36:	83 ec 0c             	sub    $0xc,%esp
80106d39:	8b 75 08             	mov    0x8(%ebp),%esi
  uint i;

  if(pgdir == 0)
80106d3c:	85 f6                	test   %esi,%esi
80106d3e:	74 59                	je     80106d99 <freevm+0x69>
80106d40:	31 c9                	xor    %ecx,%ecx
80106d42:	ba 00 00 00 80       	mov    $0x80000000,%edx
80106d47:	89 f0                	mov    %esi,%eax
80106d49:	e8 a2 fa ff ff       	call   801067f0 <deallocuvm.part.0>
80106d4e:	89 f3                	mov    %esi,%ebx
80106d50:	8d be 00 10 00 00    	lea    0x1000(%esi),%edi
80106d56:	eb 0f                	jmp    80106d67 <freevm+0x37>
80106d58:	90                   	nop
80106d59:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80106d60:	83 c3 04             	add    $0x4,%ebx
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d63:	39 fb                	cmp    %edi,%ebx
80106d65:	74 23                	je     80106d8a <freevm+0x5a>
    if(pgdir[i] & PTE_P){
80106d67:	8b 03                	mov    (%ebx),%eax
80106d69:	a8 01                	test   $0x1,%al
80106d6b:	74 f3                	je     80106d60 <freevm+0x30>
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
80106d6d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
80106d72:	83 ec 0c             	sub    $0xc,%esp
80106d75:	83 c3 04             	add    $0x4,%ebx
80106d78:	05 00 00 00 80       	add    $0x80000000,%eax
80106d7d:	50                   	push   %eax
80106d7e:	e8 5d b5 ff ff       	call   801022e0 <kfree>
80106d83:	83 c4 10             	add    $0x10,%esp
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
  deallocuvm(pgdir, KERNBASE, 0);
  for(i = 0; i < NPDENTRIES; i++){
80106d86:	39 fb                	cmp    %edi,%ebx
80106d88:	75 dd                	jne    80106d67 <freevm+0x37>
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d8a:	89 75 08             	mov    %esi,0x8(%ebp)
}
80106d8d:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106d90:	5b                   	pop    %ebx
80106d91:	5e                   	pop    %esi
80106d92:	5f                   	pop    %edi
80106d93:	5d                   	pop    %ebp
    if(pgdir[i] & PTE_P){
      char * v = P2V(PTE_ADDR(pgdir[i]));
      kfree(v);
    }
  }
  kfree((char*)pgdir);
80106d94:	e9 47 b5 ff ff       	jmp    801022e0 <kfree>
freevm(pde_t *pgdir)
{
  uint i;

  if(pgdir == 0)
    panic("freevm: no pgdir");
80106d99:	83 ec 0c             	sub    $0xc,%esp
80106d9c:	68 4d 7a 10 80       	push   $0x80107a4d
80106da1:	e8 ca 95 ff ff       	call   80100370 <panic>
80106da6:	8d 76 00             	lea    0x0(%esi),%esi
80106da9:	8d bc 27 00 00 00 00 	lea    0x0(%edi,%eiz,1),%edi

80106db0 <setupkvm>:
};

// Set up kernel part of a page table.
pde_t*
setupkvm(void)
{
80106db0:	55                   	push   %ebp
80106db1:	89 e5                	mov    %esp,%ebp
80106db3:	56                   	push   %esi
80106db4:	53                   	push   %ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
80106db5:	e8 d6 b6 ff ff       	call   80102490 <kalloc>
80106dba:	85 c0                	test   %eax,%eax
80106dbc:	74 6a                	je     80106e28 <setupkvm+0x78>
    return 0;
  memset(pgdir, 0, PGSIZE);
80106dbe:	83 ec 04             	sub    $0x4,%esp
80106dc1:	89 c6                	mov    %eax,%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106dc3:	bb 80 a4 10 80       	mov    $0x8010a480,%ebx
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
80106dc8:	68 00 10 00 00       	push   $0x1000
80106dcd:	6a 00                	push   $0x0
80106dcf:	50                   	push   %eax
80106dd0:	e8 7b d6 ff ff       	call   80104450 <memset>
80106dd5:	83 c4 10             	add    $0x10,%esp
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
80106dd8:	8b 43 04             	mov    0x4(%ebx),%eax
80106ddb:	8b 4b 08             	mov    0x8(%ebx),%ecx
80106dde:	83 ec 08             	sub    $0x8,%esp
80106de1:	8b 13                	mov    (%ebx),%edx
80106de3:	ff 73 0c             	pushl  0xc(%ebx)
80106de6:	50                   	push   %eax
80106de7:	29 c1                	sub    %eax,%ecx
80106de9:	89 f0                	mov    %esi,%eax
80106deb:	e8 70 f9 ff ff       	call   80106760 <mappages>
80106df0:	83 c4 10             	add    $0x10,%esp
80106df3:	85 c0                	test   %eax,%eax
80106df5:	78 19                	js     80106e10 <setupkvm+0x60>
  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
  memset(pgdir, 0, PGSIZE);
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
80106df7:	83 c3 10             	add    $0x10,%ebx
80106dfa:	81 fb c0 a4 10 80    	cmp    $0x8010a4c0,%ebx
80106e00:	75 d6                	jne    80106dd8 <setupkvm+0x28>
80106e02:	89 f0                	mov    %esi,%eax
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
    }
  return pgdir;
}
80106e04:	8d 65 f8             	lea    -0x8(%ebp),%esp
80106e07:	5b                   	pop    %ebx
80106e08:	5e                   	pop    %esi
80106e09:	5d                   	pop    %ebp
80106e0a:	c3                   	ret    
80106e0b:	90                   	nop
80106e0c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  if (P2V(PHYSTOP) > (void*)DEVSPACE)
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
80106e10:	83 ec 0c             	sub    $0xc,%esp
80106e13:	56                   	push   %esi
80106e14:	e8 17 ff ff ff       	call   80106d30 <freevm>
      return 0;
80106e19:	83 c4 10             	add    $0x10,%esp
    }
  return pgdir;
}
80106e1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
    panic("PHYSTOP too high");
  for(k = kmap; k < &kmap[NELEM(kmap)]; k++)
    if(mappages(pgdir, k->virt, k->phys_end - k->phys_start,
                (uint)k->phys_start, k->perm) < 0) {
      freevm(pgdir);
      return 0;
80106e1f:	31 c0                	xor    %eax,%eax
    }
  return pgdir;
}
80106e21:	5b                   	pop    %ebx
80106e22:	5e                   	pop    %esi
80106e23:	5d                   	pop    %ebp
80106e24:	c3                   	ret    
80106e25:	8d 76 00             	lea    0x0(%esi),%esi
{
  pde_t *pgdir;
  struct kmap *k;

  if((pgdir = (pde_t*)kalloc()) == 0)
    return 0;
80106e28:	31 c0                	xor    %eax,%eax
80106e2a:	eb d8                	jmp    80106e04 <setupkvm+0x54>
80106e2c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106e30 <kvmalloc>:

// Allocate one page table for the machine for the kernel address
// space for scheduler processes.
void
kvmalloc(void)
{
80106e30:	55                   	push   %ebp
80106e31:	89 e5                	mov    %esp,%ebp
80106e33:	83 ec 08             	sub    $0x8,%esp
  kpgdir = setupkvm();
80106e36:	e8 75 ff ff ff       	call   80106db0 <setupkvm>
80106e3b:	a3 04 57 11 80       	mov    %eax,0x80115704
80106e40:	05 00 00 00 80       	add    $0x80000000,%eax
80106e45:	0f 22 d8             	mov    %eax,%cr3
  switchkvm();
}
80106e48:	c9                   	leave  
80106e49:	c3                   	ret    
80106e4a:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi

80106e50 <clearpteu>:

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e50:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e51:	31 c9                	xor    %ecx,%ecx

// Clear PTE_U on a page. Used to create an inaccessible
// page beneath the user stack.
void
clearpteu(pde_t *pgdir, char *uva)
{
80106e53:	89 e5                	mov    %esp,%ebp
80106e55:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106e58:	8b 55 0c             	mov    0xc(%ebp),%edx
80106e5b:	8b 45 08             	mov    0x8(%ebp),%eax
80106e5e:	e8 7d f8 ff ff       	call   801066e0 <walkpgdir>
  if(pte == 0)
80106e63:	85 c0                	test   %eax,%eax
80106e65:	74 05                	je     80106e6c <clearpteu+0x1c>
    panic("clearpteu");
  *pte &= ~PTE_U;
80106e67:	83 20 fb             	andl   $0xfffffffb,(%eax)
}
80106e6a:	c9                   	leave  
80106e6b:	c3                   	ret    
{
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
  if(pte == 0)
    panic("clearpteu");
80106e6c:	83 ec 0c             	sub    $0xc,%esp
80106e6f:	68 5e 7a 10 80       	push   $0x80107a5e
80106e74:	e8 f7 94 ff ff       	call   80100370 <panic>
80106e79:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi

80106e80 <copyuvm>:

// Given a parent process's page table, create a copy
// of it for a child.
pde_t*
copyuvm(pde_t *pgdir, uint sz)
{
80106e80:	55                   	push   %ebp
80106e81:	89 e5                	mov    %esp,%ebp
80106e83:	57                   	push   %edi
80106e84:	56                   	push   %esi
80106e85:	53                   	push   %ebx
80106e86:	83 ec 1c             	sub    $0x1c,%esp
  pde_t *d;
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
80106e89:	e8 22 ff ff ff       	call   80106db0 <setupkvm>
80106e8e:	85 c0                	test   %eax,%eax
80106e90:	89 45 e0             	mov    %eax,-0x20(%ebp)
80106e93:	0f 84 c5 00 00 00    	je     80106f5e <copyuvm+0xde>
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106e99:	8b 4d 0c             	mov    0xc(%ebp),%ecx
80106e9c:	85 c9                	test   %ecx,%ecx
80106e9e:	0f 84 9c 00 00 00    	je     80106f40 <copyuvm+0xc0>
80106ea4:	31 ff                	xor    %edi,%edi
80106ea6:	eb 4a                	jmp    80106ef2 <copyuvm+0x72>
80106ea8:	90                   	nop
80106ea9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
80106eb0:	83 ec 04             	sub    $0x4,%esp
80106eb3:	81 c3 00 00 00 80    	add    $0x80000000,%ebx
80106eb9:	68 00 10 00 00       	push   $0x1000
80106ebe:	53                   	push   %ebx
80106ebf:	50                   	push   %eax
80106ec0:	e8 3b d6 ff ff       	call   80104500 <memmove>
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
80106ec5:	58                   	pop    %eax
80106ec6:	8d 86 00 00 00 80    	lea    -0x80000000(%esi),%eax
80106ecc:	b9 00 10 00 00       	mov    $0x1000,%ecx
80106ed1:	5a                   	pop    %edx
80106ed2:	ff 75 e4             	pushl  -0x1c(%ebp)
80106ed5:	50                   	push   %eax
80106ed6:	89 fa                	mov    %edi,%edx
80106ed8:	8b 45 e0             	mov    -0x20(%ebp),%eax
80106edb:	e8 80 f8 ff ff       	call   80106760 <mappages>
80106ee0:	83 c4 10             	add    $0x10,%esp
80106ee3:	85 c0                	test   %eax,%eax
80106ee5:	78 69                	js     80106f50 <copyuvm+0xd0>
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106ee7:	81 c7 00 10 00 00    	add    $0x1000,%edi
80106eed:	39 7d 0c             	cmp    %edi,0xc(%ebp)
80106ef0:	76 4e                	jbe    80106f40 <copyuvm+0xc0>
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
80106ef2:	8b 45 08             	mov    0x8(%ebp),%eax
80106ef5:	31 c9                	xor    %ecx,%ecx
80106ef7:	89 fa                	mov    %edi,%edx
80106ef9:	e8 e2 f7 ff ff       	call   801066e0 <walkpgdir>
80106efe:	85 c0                	test   %eax,%eax
80106f00:	74 6d                	je     80106f6f <copyuvm+0xef>
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
80106f02:	8b 00                	mov    (%eax),%eax
80106f04:	a8 01                	test   $0x1,%al
80106f06:	74 5a                	je     80106f62 <copyuvm+0xe2>
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f08:	89 c3                	mov    %eax,%ebx
    flags = PTE_FLAGS(*pte);
80106f0a:	25 ff 0f 00 00       	and    $0xfff,%eax
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
    pa = PTE_ADDR(*pte);
80106f0f:	81 e3 00 f0 ff ff    	and    $0xfffff000,%ebx
    flags = PTE_FLAGS(*pte);
80106f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if((mem = kalloc()) == 0)
80106f18:	e8 73 b5 ff ff       	call   80102490 <kalloc>
80106f1d:	85 c0                	test   %eax,%eax
80106f1f:	89 c6                	mov    %eax,%esi
80106f21:	75 8d                	jne    80106eb0 <copyuvm+0x30>
    }
  }
  return d;

bad:
  freevm(d);
80106f23:	83 ec 0c             	sub    $0xc,%esp
80106f26:	ff 75 e0             	pushl  -0x20(%ebp)
80106f29:	e8 02 fe ff ff       	call   80106d30 <freevm>
  return 0;
80106f2e:	83 c4 10             	add    $0x10,%esp
80106f31:	31 c0                	xor    %eax,%eax
}
80106f33:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f36:	5b                   	pop    %ebx
80106f37:	5e                   	pop    %esi
80106f38:	5f                   	pop    %edi
80106f39:	5d                   	pop    %ebp
80106f3a:	c3                   	ret    
80106f3b:	90                   	nop
80106f3c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
80106f40:	8b 45 e0             	mov    -0x20(%ebp),%eax
  return d;

bad:
  freevm(d);
  return 0;
}
80106f43:	8d 65 f4             	lea    -0xc(%ebp),%esp
80106f46:	5b                   	pop    %ebx
80106f47:	5e                   	pop    %esi
80106f48:	5f                   	pop    %edi
80106f49:	5d                   	pop    %ebp
80106f4a:	c3                   	ret    
80106f4b:	90                   	nop
80106f4c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto bad;
    memmove(mem, (char*)P2V(pa), PGSIZE);
    if(mappages(d, (void*)i, PGSIZE, V2P(mem), flags) < 0) {
      kfree(mem);
80106f50:	83 ec 0c             	sub    $0xc,%esp
80106f53:	56                   	push   %esi
80106f54:	e8 87 b3 ff ff       	call   801022e0 <kfree>
      goto bad;
80106f59:	83 c4 10             	add    $0x10,%esp
80106f5c:	eb c5                	jmp    80106f23 <copyuvm+0xa3>
  pte_t *pte;
  uint pa, i, flags;
  char *mem;

  if((d = setupkvm()) == 0)
    return 0;
80106f5e:	31 c0                	xor    %eax,%eax
80106f60:	eb d1                	jmp    80106f33 <copyuvm+0xb3>
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
    if(!(*pte & PTE_P))
      panic("copyuvm: page not present");
80106f62:	83 ec 0c             	sub    $0xc,%esp
80106f65:	68 82 7a 10 80       	push   $0x80107a82
80106f6a:	e8 01 94 ff ff       	call   80100370 <panic>

  if((d = setupkvm()) == 0)
    return 0;
  for(i = 0; i < sz; i += PGSIZE){
    if((pte = walkpgdir(pgdir, (void *) i, 0)) == 0)
      panic("copyuvm: pte should exist");
80106f6f:	83 ec 0c             	sub    $0xc,%esp
80106f72:	68 68 7a 10 80       	push   $0x80107a68
80106f77:	e8 f4 93 ff ff       	call   80100370 <panic>
80106f7c:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

80106f80 <uva2ka>:

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f80:	55                   	push   %ebp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f81:	31 c9                	xor    %ecx,%ecx

//PAGEBREAK!
// Map user virtual address to kernel address.
char*
uva2ka(pde_t *pgdir, char *uva)
{
80106f83:	89 e5                	mov    %esp,%ebp
80106f85:	83 ec 08             	sub    $0x8,%esp
  pte_t *pte;

  pte = walkpgdir(pgdir, uva, 0);
80106f88:	8b 55 0c             	mov    0xc(%ebp),%edx
80106f8b:	8b 45 08             	mov    0x8(%ebp),%eax
80106f8e:	e8 4d f7 ff ff       	call   801066e0 <walkpgdir>
  if((*pte & PTE_P) == 0)
80106f93:	8b 00                	mov    (%eax),%eax
    return 0;
  if((*pte & PTE_U) == 0)
80106f95:	89 c2                	mov    %eax,%edx
80106f97:	83 e2 05             	and    $0x5,%edx
80106f9a:	83 fa 05             	cmp    $0x5,%edx
80106f9d:	75 11                	jne    80106fb0 <uva2ka+0x30>
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106f9f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
}
80106fa4:	c9                   	leave  
  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  return (char*)P2V(PTE_ADDR(*pte));
80106fa5:	05 00 00 00 80       	add    $0x80000000,%eax
}
80106faa:	c3                   	ret    
80106fab:	90                   	nop
80106fac:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi

  pte = walkpgdir(pgdir, uva, 0);
  if((*pte & PTE_P) == 0)
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
80106fb0:	31 c0                	xor    %eax,%eax
  return (char*)P2V(PTE_ADDR(*pte));
}
80106fb2:	c9                   	leave  
80106fb3:	c3                   	ret    
80106fb4:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
80106fba:	8d bf 00 00 00 00    	lea    0x0(%edi),%edi

80106fc0 <copyout>:
// Copy len bytes from p to user address va in page table pgdir.
// Most useful when pgdir is not the current page table.
// uva2ka ensures this only works for PTE_U pages.
int
copyout(pde_t *pgdir, uint va, void *p, uint len)
{
80106fc0:	55                   	push   %ebp
80106fc1:	89 e5                	mov    %esp,%ebp
80106fc3:	57                   	push   %edi
80106fc4:	56                   	push   %esi
80106fc5:	53                   	push   %ebx
80106fc6:	83 ec 1c             	sub    $0x1c,%esp
80106fc9:	8b 5d 14             	mov    0x14(%ebp),%ebx
80106fcc:	8b 55 0c             	mov    0xc(%ebp),%edx
80106fcf:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80106fd2:	85 db                	test   %ebx,%ebx
80106fd4:	75 40                	jne    80107016 <copyout+0x56>
80106fd6:	eb 70                	jmp    80107048 <copyout+0x88>
80106fd8:	90                   	nop
80106fd9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (va - va0);
80106fe0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
80106fe3:	89 f1                	mov    %esi,%ecx
80106fe5:	29 d1                	sub    %edx,%ecx
80106fe7:	81 c1 00 10 00 00    	add    $0x1000,%ecx
80106fed:	39 d9                	cmp    %ebx,%ecx
80106fef:	0f 47 cb             	cmova  %ebx,%ecx
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
80106ff2:	29 f2                	sub    %esi,%edx
80106ff4:	83 ec 04             	sub    $0x4,%esp
80106ff7:	01 d0                	add    %edx,%eax
80106ff9:	51                   	push   %ecx
80106ffa:	57                   	push   %edi
80106ffb:	50                   	push   %eax
80106ffc:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
80106fff:	e8 fc d4 ff ff       	call   80104500 <memmove>
    len -= n;
    buf += n;
80107004:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107007:	83 c4 10             	add    $0x10,%esp
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
8010700a:	8d 96 00 10 00 00    	lea    0x1000(%esi),%edx
    n = PGSIZE - (va - va0);
    if(n > len)
      n = len;
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
80107010:	01 cf                	add    %ecx,%edi
{
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
80107012:	29 cb                	sub    %ecx,%ebx
80107014:	74 32                	je     80107048 <copyout+0x88>
    va0 = (uint)PGROUNDDOWN(va);
80107016:	89 d6                	mov    %edx,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107018:	83 ec 08             	sub    $0x8,%esp
  char *buf, *pa0;
  uint n, va0;

  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
8010701b:	89 55 e4             	mov    %edx,-0x1c(%ebp)
8010701e:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
    pa0 = uva2ka(pgdir, (char*)va0);
80107024:	56                   	push   %esi
80107025:	ff 75 08             	pushl  0x8(%ebp)
80107028:	e8 53 ff ff ff       	call   80106f80 <uva2ka>
    if(pa0 == 0)
8010702d:	83 c4 10             	add    $0x10,%esp
80107030:	85 c0                	test   %eax,%eax
80107032:	75 ac                	jne    80106fe0 <copyout+0x20>
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
80107034:	8d 65 f4             	lea    -0xc(%ebp),%esp
  buf = (char*)p;
  while(len > 0){
    va0 = (uint)PGROUNDDOWN(va);
    pa0 = uva2ka(pgdir, (char*)va0);
    if(pa0 == 0)
      return -1;
80107037:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
}
8010703c:	5b                   	pop    %ebx
8010703d:	5e                   	pop    %esi
8010703e:	5f                   	pop    %edi
8010703f:	5d                   	pop    %ebp
80107040:	c3                   	ret    
80107041:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
80107048:	8d 65 f4             	lea    -0xc(%ebp),%esp
    memmove(pa0 + (va - va0), buf, n);
    len -= n;
    buf += n;
    va = va0 + PGSIZE;
  }
  return 0;
8010704b:	31 c0                	xor    %eax,%eax
}
8010704d:	5b                   	pop    %ebx
8010704e:	5e                   	pop    %esi
8010704f:	5f                   	pop    %edi
80107050:	5d                   	pop    %ebp
80107051:	c3                   	ret    
